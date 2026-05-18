import 'package:flutter/material.dart';
import '../models/date_idea.dart';

/// A beautiful card widget displaying a date idea.
class DateCard extends StatelessWidget {
  final DateIdea dateIdea;
  final VoidCallback? onTap;
  final bool isWinner;
  final bool isCompactBattle;

  const DateCard({
    super.key,
    required this.dateIdea,
    this.onTap,
    this.isWinner = false,
    this.isCompactBattle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 430;
    final horizontalMargin = isWinner ? 44.0 : 28.0;
    final maxCardWidth = isWinner ? 360.0 : 380.0;
    final minCardWidth = isWinner ? 286.0 : 280.0;
    final cardWidth = (screenWidth - horizontalMargin)
        .clamp(minCardWidth, maxCardWidth)
        .toDouble();
    final cardHeight = (cardWidth * (isWinner ? 1.26 : 1.3))
        .clamp(isWinner ? 390.0 : 360.0, isWinner ? 470.0 : 460.0)
        .toDouble();

    if (isCompactBattle) {
      return _buildCompactBattleCard(context, theme);
    }

    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(
                alpha: isWinner ? 0.22 : 0.14,
              ),
              blurRadius: isWinner ? 28 : 20,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: isWinner ? 6 : 7,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildImage(),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.48),
                              ],
                              stops: const [0.45, 0.7, 1],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        left: 14,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isCompact ? 10 : 12,
                            vertical: isCompact ? 6 : 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.86),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isWinner ? 'Winning pick' : 'Head-to-head',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isCompactBattle
                                ? 9
                                : (isCompact ? 10 : 12),
                            vertical: isCompactBattle ? 5 : (isCompact ? 6 : 7),
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: isCompact ? 12 : 14,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                              SizedBox(width: isCompact ? 4 : 6),
                              Text(
                                dateIdea.time,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: isCompact ? 10 : null,
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        right: 18,
                        bottom: 18,
                        child: Text(
                          dateIdea.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: isCompact ? 24 : 28,
                            color: Colors.white,
                            height: 1.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: isWinner ? 4 : 5,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isCompact ? 16 : 18,
                      isCompact ? 14 : 16,
                      isCompact ? 16 : 18,
                      isCompact ? 16 : 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer
                                .withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isWinner ? 'Final answer' : 'Tap if this wins',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: isCompact ? 10 : 12),
                        Expanded(
                          child: Text(
                            dateIdea.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: isCompact ? 13.5 : 14.5,
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.45,
                            ),
                          ),
                        ),
                        if (onTap != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  theme.colorScheme.secondary.withValues(
                                    alpha: 0.12,
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_rounded,
                                  size: isCompact ? 16 : 18,
                                  color: theme.colorScheme.primary,
                                ),
                                SizedBox(width: isCompact ? 6 : 8),
                                Text(
                                  'Choose this idea',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactBattleCard(BuildContext context, ThemeData theme) {
    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                dateIdea.time,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.favorite_rounded,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dateIdea.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            dateIdea.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.25,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isWinner ? 'Final answer' : 'Choose this idea',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildImage(alignment: Alignment.center),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isWinner ? 'Winner' : 'Tap',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage({Alignment alignment = Alignment.center}) {
    return Image.asset(
      dateIdea.imagePath,
      fit: BoxFit.cover,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera_back,
                  size: 48,
                  color: Colors.grey[500],
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your image',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
