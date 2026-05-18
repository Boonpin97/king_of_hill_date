import 'package:flutter/material.dart';
import '../models/date_idea.dart';
import '../widgets/date_card.dart';

/// The final result screen showing the winning date idea.
class ResultScreen extends StatefulWidget {
  final DateIdea winner;
  final VoidCallback onRestart;

  const ResultScreen({
    super.key,
    required this.winner,
    required this.onRestart,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.sizeOf(context);
    final isCompact = screenSize.width < 430;
    final isShortMobile = isCompact && screenSize.height < 740;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withValues(alpha: 0.22),
              theme.colorScheme.secondaryContainer.withValues(alpha: 0.24),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    isShortMobile ? 14 : (isCompact ? 20 : 24),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        isCompact ? 18 : 24,
                        isShortMobile ? 18 : (isCompact ? 22 : 28),
                        isCompact ? 18 : 24,
                        isShortMobile ? 18 : (isCompact ? 20 : 24),
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(
                          alpha: 0.82,
                        ),
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.06,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withValues(
                              alpha: 0.12,
                            ),
                            blurRadius: 32,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              isShortMobile ? 12 : (isCompact ? 14 : 16),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.28,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.celebration_rounded,
                              size: isShortMobile ? 26 : (isCompact ? 30 : 36),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: isShortMobile ? 10 : (isCompact ? 16 : 20),
                          ),
                          Text(
                            'It\'s a Date!',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: isShortMobile
                                  ? 26
                                  : (isCompact ? 30 : null),
                              color: theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (!isShortMobile) ...[
                            SizedBox(height: isCompact ? 10 : 12),
                            Text(
                              'This one made it through every round. Lock it in before you overthink it.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          SizedBox(
                            height: isShortMobile ? 12 : (isCompact ? 20 : 24),
                          ),
                          SizedBox(
                            height: isShortMobile ? 290 : null,
                            child: DateCard(
                              dateIdea: widget.winner,
                              isWinner: true,
                              isCompactBattle: isShortMobile,
                            ),
                          ),
                          if (!isShortMobile) ...[
                            SizedBox(height: isCompact ? 22 : 28),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                Icon(
                                  Icons.favorite_rounded,
                                  color: theme.colorScheme.primary,
                                  size: isCompact ? 18 : 20,
                                ),
                                Text(
                                  'Can\'t wait to spend this time with you.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: isCompact ? 14 : null,
                                    color: theme.colorScheme.onSurface,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                          SizedBox(
                            height: isShortMobile ? 14 : (isCompact ? 24 : 30),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: widget.onRestart,
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Start another round'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
