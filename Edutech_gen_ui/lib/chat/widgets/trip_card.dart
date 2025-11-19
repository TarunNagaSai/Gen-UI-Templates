import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> activities;
  final String? bestTimeToVisit;

  const TripCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.activities,
    this.bestTimeToVisit,
  });

  factory TripCard.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? '';
    final description = json['description'] as String? ?? '';
    final imageUrl = json['imageUrl'] as String? ?? '';
    final activities =
        (json['activities'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final bestTime = json['bestTimeToVisit'] as String?;

    return TripCard(
      title: title,
      description: description,
      imageUrl: imageUrl,
      activities: activities,
      bestTimeToVisit: bestTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          // if (imageUrl.isNotEmpty)
          //   AspectRatio(
          //     aspectRatio: 16 / 9,
          //     child: Image.network(
          //       imageUrl,
          //       fit: BoxFit.cover,
          //       errorBuilder: (_, __, ___) => Container(
          //         color: theme.colorScheme.surfaceContainerHighest,
          //         alignment: Alignment.center,
          //         child: Icon(
          //           Icons.image_not_supported_outlined,
          //           color: theme.colorScheme.onSurface.withOpacity(0.5),
          //         ),
          //       ),
          //     ),
          //   ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),

                // Best time to visit
                if (bestTimeToVisit != null && bestTimeToVisit!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Best time: ${bestTimeToVisit!}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Activities
                if (activities.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Activities',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: activities
                        .map(
                          (a) => Chip(
                            label: Text(a),
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
