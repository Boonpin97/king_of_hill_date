import 'package:flutter/material.dart';
import '../models/date_idea.dart';
import '../widgets/date_card.dart';

/// The main comparison screen implementing the "King of the Hill" algorithm.
///
/// How it works:
/// 1. The first idea becomes the initial "champion"
/// 2. The next idea is the "challenger"
/// 3. User picks one - the winner becomes the new champion
/// 4. Next challenger appears
/// 5. Continues until all ideas have competed
/// 6. Final champion is the winning date idea
class ComparisonScreen extends StatefulWidget {
  final List<DateIdea> dateIdeas;
  final void Function(DateIdea winner) onComplete;

  const ComparisonScreen({
    super.key,
    required this.dateIdeas,
    required this.onComplete,
  });

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen>
    with TickerProviderStateMixin {
  late DateIdea _leftIdea; // Idea on the left/top
  late DateIdea _rightIdea; // Idea on the right/bottom
  int _currentRound = 1; // Which comparison we're on (1-based)
  int _nextIdeaIndex = 2; // Index of next idea in the list

  // Animation controllers
  late AnimationController _leftController;
  late AnimationController _rightController;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;

  bool _isAnimating = false;
  DateIdea? _selectedIdea;

  int get _totalRounds => widget.dateIdeas.length - 1;

  @override
  void initState() {
    super.initState();

    // Initialize with first two ideas
    _leftIdea = widget.dateIdeas[0];
    _rightIdea = widget.dateIdeas[1];
    _nextIdeaIndex = 2;

    // Setup animations
    _leftController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _rightController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _leftSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero, // Will be set dynamically
    ).animate(CurvedAnimation(
      parent: _leftController,
      curve: Curves.easeInBack,
    ));

    _rightSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero, // Will be set dynamically
    ).animate(CurvedAnimation(
      parent: _rightController,
      curve: Curves.easeOutBack,
    ));

    // Initial animation will be triggered after first frame to get screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isWideScreen = screenWidth > 700;
      final enterRight = isWideScreen ? const Offset(1.5, 0) : const Offset(0, 1.5);
      
      _rightSlideAnimation = Tween<Offset>(
        begin: enterRight,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _rightController,
        curve: Curves.easeOutBack,
      ));
      _rightController.forward();
    });
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  void _handleSelection(DateIdea selected, DateIdea loser) async {
    if (_isAnimating) return;

    final leftWon = selected == _leftIdea;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 700;

    setState(() {
      _isAnimating = true;
      _selectedIdea = selected;
    });

    // Determine animation offsets based on layout
    final exitLeft = isWideScreen ? const Offset(-1.5, 0) : const Offset(0, -1.5);
    final exitRight = isWideScreen ? const Offset(1.5, 0) : const Offset(0, 1.5);
    final enterLeft = isWideScreen ? const Offset(-1.5, 0) : const Offset(0, -1.5);
    final enterRight = isWideScreen ? const Offset(1.5, 0) : const Offset(0, 1.5);

    // Animate losing card out
    if (leftWon) {
      // Left won - slide right out
      _rightSlideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: exitRight,
      ).animate(CurvedAnimation(
        parent: _rightController,
        curve: Curves.easeInBack,
      ));
      _rightController.reset();
      await _rightController.forward();
    } else {
      // Right won - slide left out
      _leftSlideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: exitLeft,
      ).animate(CurvedAnimation(
        parent: _leftController,
        curve: Curves.easeInBack,
      ));
      _leftController.reset();
      await _leftController.forward();
    }

    // Check if we're done
    if (_nextIdeaIndex >= widget.dateIdeas.length) {
      // Competition complete!
      widget.onComplete(selected);
      return;
    }

    // Prepare next round - winner stays on its side, new challenger comes from opposite
    final nextIdea = widget.dateIdeas[_nextIdeaIndex];
    
    setState(() {
      if (leftWon) {
        // Left stays, new challenger comes from right
        _rightIdea = nextIdea;
      } else {
        // Right stays, new challenger comes from left
        _leftIdea = nextIdea;
      }
      _nextIdeaIndex++;
      _currentRound++;
      _selectedIdea = null;
    });

    // Reset and animate new challenger in
    if (leftWon) {
      // New challenger slides in from right
      _rightSlideAnimation = Tween<Offset>(
        begin: enterRight,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _rightController,
        curve: Curves.easeOutBack,
      ));
      _rightController.reset();
      await _rightController.forward();
    } else {
      // New challenger slides in from left
      _leftSlideAnimation = Tween<Offset>(
        begin: enterLeft,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _leftController,
        curve: Curves.easeOutBack,
      ));
      _leftController.reset();
      await _leftController.forward();
    }

    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 700;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerLow,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with progress
              _buildHeader(theme),

              // Cards area
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: isWideScreen
                        ? _buildHorizontalLayout()
                        : _buildVerticalLayout(),
                  ),
                ),
              ),

              // Bottom hint
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Tap the card you prefer',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Title
          Text(
            'Which one speaks to you?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Round $_currentRound of $_totalRounds',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _currentRound / _totalRounds,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left card
        SlideTransition(
          position: _leftSlideAnimation,
          child: _buildLeftCard(),
        ),

        // VS indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildVsIndicator(),
        ),

        // Right card
        SlideTransition(
          position: _rightSlideAnimation,
          child: _buildRightCard(),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top card (left in horizontal)
        SlideTransition(
          position: _leftSlideAnimation,
          child: _buildLeftCard(),
        ),

        // VS indicator
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: _buildVsIndicator(),
        ),

        // Bottom card (right in horizontal)
        SlideTransition(
          position: _rightSlideAnimation,
          child: _buildRightCard(),
        ),
      ],
    );
  }

  Widget _buildLeftCard() {
    final isSelected = _selectedIdea == _leftIdea;
    return AnimatedScale(
      scale: isSelected ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: DateCard(
        dateIdea: _leftIdea,
        onTap: _isAnimating
            ? null
            : () => _handleSelection(_leftIdea, _rightIdea),
      ),
    );
  }

  Widget _buildRightCard() {
    final isSelected = _selectedIdea == _rightIdea;
    return AnimatedScale(
      scale: isSelected ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: DateCard(
        dateIdea: _rightIdea,
        onTap: _isAnimating
            ? null
            : () => _handleSelection(_rightIdea, _leftIdea),
      ),
    );
  }

  Widget _buildVsIndicator() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        'VS',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }
}
