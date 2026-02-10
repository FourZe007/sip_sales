import 'package:flutter/material.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

// A reusable card widget to display a task or report.
// It accepts parameters to make it flexible for different types of tasks.
class HeadTasksCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final List<int> points;
  final VoidCallback onTap; // Callback function for when the card is tapped
  final VoidCallback onDelete; // Callback function for when delete is selected

  const HeadTasksCard({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
    required this.points,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Adds a subtle shadow to lift the card off the background
      elevation: 2.0,
      // margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        // The InkWell makes the entire card tappable with a visual splash effect
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // The Row widget arranges the content horizontally
          child: Row(
            spacing: 16,
            children: [
              // The icon representing the task type
              Icon(icon, size: 36.0, color: Colors.black),

              // The Expanded widget ensures the text column takes up available space
              Expanded(
                // The Column widget arranges the title and time vertically
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // The main title of the task
                    Text(
                      title,
                      style: TextThemes.normal.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.transparent,
                      ),
                    ),

                    // The secondary info (time)
                    Text(
                      'Pukul $time',
                      style: TextThemes.normal.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    // ~:Points:~
                    Row(
                      spacing: 8,
                      children: points
                          .map(
                            (point) => Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$point pts',
                                textAlign: TextAlign.center,
                                style: TextThemes.normal.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              // The three-dot "more options" menu
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                shadowColor: Colors.grey,
                elevation: 4,
                onSelected: (value) {
                  if (value == 'more') {
                    onTap();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  // The "More" option in the menu
                  PopupMenuItem<String>(
                    value: 'more',
                    child: Text(
                      'Lihat Detail',
                      style: TextThemes.normal.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),

                  // The "Delete" option in the menu
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(
                      'Hapus',
                      style: TextThemes.normal.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
