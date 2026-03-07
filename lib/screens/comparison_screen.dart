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
  late DateIdea _champion; // Current "king of the hill"
  late DateIdea _challenger; // Current challenger
  int _currentRound = 1; // Which comparison we're on (1-based)
  int _challengerIndex = 1; // Index of next challenger in the list

  // Animation controllers
  late AnimationController _championController;
  late AnimationController _challengerController;
  late Animation<Offset> _championSlideAnimation;
  late Animation<Offset> _challengerSlideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isAnimating = false;
  DateIdea? _selectedIdea;

  int get _totalRounds => widget.dateIdeas.length - 1;

  @override
  void initState() {
    super.initState();

    // Initialize with first two ideas
    _champion = widget.dateIdeas[0];
    _challenger = widget.dateIdeas[1];
    _challengerIndex = 2;

    // Setup animations
    _championController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _challengerController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _championSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.5, 0),
    ).animate(CurvedAnimation(
      parent: _championController,
      curve: Curves.easeInBack,
    ));

    _challengerSlideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _challengerController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _championController,
      curve: Curves.easeIn,
    ));

    // Start with challenger sliding in
    _challengerController.forward();
  }

  @override
  void dispose() {
    _championController.dispose();
    _challengerController.dispose();
    super.dispose();
  }

  void _handleSelection(DateIdea selected, DateIdea loser) async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _selectedIdea = selected;
    });

    // Animate losing card out
    if (loser == _champion) {
      await _championController.forward();
    } else {
      _challengerSlideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1.5, 0),
      ).animate(CurvedAnimation(
        parent: _challengerController,
        curve: Curves.easeInBack,
      ));
      _challengerController.reset();
      await _challengerController.forward();
    }

    // Check if we're done
    if (_challengerIndex >= widget.dateIdeas.length) {
      // Competition complete!
      widget.onComplete(selected);
      return;
    }

    // Prepare next round
    setState(() {
      _champion = selected;
      _challenger = widget.dateIdeas[_challengerIndex];
      _challengerIndex++;
      _currentRound++;
      _selectedIdea = null;
    });

    // Reset animations
    _championController.reset();
    _challengerSlideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _challengerController,
      curve: Curves.easeOutBack,
    ));
    _challengerController.reset();

    // Animate new challenger in
    await _challengerController.forward();

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
        // Champion card (left)
        SlideTransition(
          position: _championSlideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildChampionCard(),
          ),
        ),

        // VS indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildVsIndicator(),
        ),

        // Challenger card (right)
        SlideTransition(
          position: _challengerSlideAnimation,
          child: _buildChallengerCard(),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Champion card (top)
        SlideTransition(
          position: _championSlideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildChampionCard(),
          ),
        ),

        // VS indicator
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: _buildVsIndicator(),
        ),

        // Challenger card (bottom)
        SlideTransition(
          position: _challengerSlideAnimation,
          child: _buildChallengerCard(),
        ),
      ],
    );
  }

  Widget _buildChampionCard() {
    final isSelected = _selectedIdea == _champion;
    return AnimatedScale(
      scale: isSelected ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: DateCard(
        dateIdea: _champion,
        onTap: _isAnimating
            ? null
            : () => _handleSelection(_champion, _challenger),
      ),
    );
  }

  Widget _buildChallengerCard() {
    final isSelected = _selectedIdea == _challenger;
    return AnimatedScale(
      scale: isSelected ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: DateCard(
        dateIdea: _challenger,
        onTap: _isAnimating
            ? null
            : () => _handleSelection(_challenger, _champion),
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
