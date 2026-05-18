import 'package:flutter/material.dart';

/// The intro screen with a romantic welcome message and start button.
class IntroScreen extends StatelessWidget {
  final VoidCallback onStart;

  const IntroScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isCompact = screenSize.width < 430;
    final isShortMobile = isCompact && screenSize.height < 740;
    final isPortrait = screenSize.height > screenSize.width;
    final pagePadding = isShortMobile ? 14.0 : (isCompact ? 18.0 : 28.0);
    final maxPanelWidth = isPortrait ? 460.0 : 720.0;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withValues(alpha: 0.18),
              theme.colorScheme.secondaryContainer.withValues(alpha: 0.24),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -40,
                right: -30,
                child: _GlowOrb(
                  size: isCompact ? 160 : 220,
                  color: theme.colorScheme.primary.withValues(alpha: 0.18),
                ),
              ),
              Positioned(
                bottom: -50,
                left: -35,
                child: _GlowOrb(
                  size: isCompact ? 180 : 260,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.16),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(pagePadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxPanelWidth),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        isCompact ? 20 : 28,
                        isShortMobile ? 18 : (isCompact ? 22 : 30),
                        isCompact ? 20 : 28,
                        isShortMobile ? 18 : (isCompact ? 20 : 26),
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(
                          alpha: 0.78,
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer
                                    .withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Choose your next memory together',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: isShortMobile ? 16 : (isCompact ? 24 : 30),
                          ),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.88, end: 1.0),
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeOutBack,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: Container(
                              width: isShortMobile
                                  ? 72
                                  : (isCompact ? 92 : 108),
                              height: isShortMobile
                                  ? 72
                                  : (isCompact ? 92 : 108),
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
                                    blurRadius: 30,
                                    offset: const Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite_rounded,
                                size: isShortMobile ? 34 : 44,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: isShortMobile ? 14 : (isCompact ? 22 : 28),
                          ),
                          Text(
                            'Our Perfect Date',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontSize: isShortMobile
                                  ? 32
                                  : (isCompact ? 36 : 48),
                              color: theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: isShortMobile ? 8 : (isCompact ? 12 : 14),
                          ),
                          Text(
                            'A playful head-to-head vote between your favorite date ideas, designed to feel like a polished little mobile app instead of a form.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: isShortMobile
                                  ? 14
                                  : (isCompact ? 15 : 17),
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: isShortMobile ? 3 : null,
                            overflow: isShortMobile
                                ? TextOverflow.ellipsis
                                : TextOverflow.visible,
                            textAlign: TextAlign.center,
                          ),
                          if (!isShortMobile) ...[
                            SizedBox(height: isCompact ? 20 : 24),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 10,
                              children: const [
                                _InfoChip(
                                  icon: Icons.phone_iphone,
                                  label: 'Portrait first',
                                ),
                                _InfoChip(
                                  icon: Icons.auto_awesome,
                                  label: 'Smooth rounds',
                                ),
                                _InfoChip(
                                  icon: Icons.favorite_border,
                                  label: 'Just for us',
                                ),
                              ],
                            ),
                          ],
                          SizedBox(
                            height: isShortMobile ? 18 : (isCompact ? 26 : 32),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: onStart,
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Text(
                                  'Start choosing',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: isShortMobile ? 10 : (isCompact ? 14 : 18),
                          ),
                          Text(
                            '9 ideas, one winner, zero overthinking',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.72),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
