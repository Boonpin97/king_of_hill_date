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
  late DateIdea _leftIdea;
  late DateIdea _rightIdea;
  int _currentRound = 1;
  int _nextIdeaIndex = 2;

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

    _leftIdea = widget.dateIdeas[0];
    _rightIdea = widget.dateIdeas[1];
    _nextIdeaIndex = 2;

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
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _leftController, curve: Curves.easeInBack),
    );

    _rightSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _rightController, curve: Curves.easeOutBack),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isWideScreen = screenWidth > 700;
      final enterRight =
          isWideScreen ? const Offset(1.5, 0) : const Offset(0, 1.5);

      _rightSlideAnimation = Tween<Offset>(
        begin: enterRight,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _rightController, curve: Curves.easeOutBack),
      );
      _rightController.forward();
    });
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  Future<void> _handleSelection(DateIdea selected) async {
    if (_isAnimating) return;

    final leftWon = selected == _leftIdea;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 700;

    setState(() {
      _isAnimating = true;
      _selectedIdea = selected;
    });

    final exitLeft = isWideScreen ? const Offset(-1.5, 0) : const Offset(0, -1.5);
    final exitRight = isWideScreen ? const Offset(1.5, 0) : const Offset(0, 1.5);
    final enterLeft = isWideScreen ? const Offset(-1.5, 0) : const Offset(0, -1.5);
    final enterRight = isWideScreen ? const Offset(1.5, 0) : const Offset(0, 1.5);

    if (leftWon) {
      _rightSlideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: exitRight,
      ).animate(
        CurvedAnimation(parent: _rightController, curve: Curves.easeInBack),
      );
      _rightController.reset();
      await _rightController.forward();
    } else {
      _leftSlideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: exitLeft,
      ).animate(
        CurvedAnimation(parent: _leftController, curve: Curves.easeInBack),
      );
      _leftController.reset();
      await _leftController.forward();
    }

    if (_nextIdeaIndex >= widget.dateIdeas.length) {
      widget.onComplete(selected);
      return;
    }

    final nextIdea = widget.dateIdeas[_nextIdeaIndex];

    setState(() {
      if (leftWon) {
        _rightIdea = nextIdea;
      } else {
        _leftIdea = nextIdea;
      }
      _nextIdeaIndex++;
      _currentRound++;
      _selectedIdea = null;
    });

    if (leftWon) {
      _rightSlideAnimation = Tween<Offset>(
        begin: enterRight,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _rightController, curve: Curves.easeOutBack),
      );
      _rightController.reset();
      await _rightController.forward();
    } else {
      _leftSlideAnimation = Tween<Offset>(
        begin: enterLeft,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _leftController, curve: Curves.easeOutBack),
      );
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
    final screenSize = MediaQuery.of(context).size;
    final isWideScreen = screenSize.width > 700;
    final isCompactPortrait =
        !isWideScreen &&
        screenSize.width < 430 &&
        screenSize.height > screenSize.width;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withValues(alpha: 0.12),
              theme.colorScheme.secondaryContainer.withValues(alpha: 0.16),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(theme, isCompactPortrait),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompactPortrait ? 12 : 16,
                      vertical: isCompactPortrait ? 16 : 24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWideScreen ? 980 : 430,
                      ),
                      child: isWideScreen
                          ? _buildHorizontalLayout()
                          : _buildVerticalLayout(isCompactPortrait),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  isCompactPortrait ? 14 : 24,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Text(
                    'Tap the card you would honestly be excited to do next.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: isCompactPortrait ? 13 : 14,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isCompactPortrait) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isCompactPortrait ? 12 : 16,
        isCompactPortrait ? 12 : 16,
        isCompactPortrait ? 12 : 16,
        isCompactPortrait ? 8 : 16,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 760),
        padding: EdgeInsets.fromLTRB(
          isCompactPortrait ? 16 : 20,
          isCompactPortrait ? 16 : 18,
          isCompactPortrait ? 16 : 20,
          isCompactPortrait ? 14 : 18,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            Text(
              'Which one speaks to you?',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: isCompactPortrait ? 24 : null,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isCompactPortrait ? 8 : 10),
            Text(
              'Two ideas enter. One date plan survives.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isCompactPortrait ? 12 : 14),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompactPortrait ? 14 : 16,
                    vertical: isCompactPortrait ? 8 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Round $_currentRound of $_totalRounds',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: isCompactPortrait ? 12 : null,
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: _currentRound / _totalRounds,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      minHeight: isCompactPortrait ? 10 : 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SlideTransition(
            position: _leftSlideAnimation,
            child: Align(child: _buildLeftCard()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildVsIndicator(),
        ),
        Expanded(
          child: SlideTransition(
            position: _rightSlideAnimation,
            child: Align(child: _buildRightCard()),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout(bool isCompactPortrait) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          position: _leftSlideAnimation,
          child: _buildLeftCard(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: isCompactPortrait ? 12 : 16),
          child: _buildVsIndicator(isCompactPortrait: isCompactPortrait),
        ),
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
      scale: isSelected ? 1.03 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: DateCard(
        dateIdea: _leftIdea,
        onTap: _isAnimating ? null : () => _handleSelection(_leftIdea),
      ),
    );
  }

  Widget _buildRightCard() {
    final isSelected = _selectedIdea == _rightIdea;
    return AnimatedScale(
      scale: isSelected ? 1.03 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: DateCard(
        dateIdea: _rightIdea,
        onTap: _isAnimating ? null : () => _handleSelection(_rightIdea),
      ),
    );
  }

  Widget _buildVsIndicator({bool isCompactPortrait = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(isCompactPortrait ? 14 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.tertiaryContainer,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        'VS',
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: isCompactPortrait ? 15 : null,
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onPrimaryContainer,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
