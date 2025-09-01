import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';

// A reusable card widget to display a task or report.
// It accepts parameters to make it flexible for different types of tasks.
class HeadStoreTasks extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final VoidCallback onTap; // Callback function for when the card is tapped
  final VoidCallback onDelete; // Callback function for when delete is selected

  const HeadStoreTasks({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
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
            children: [
              // The icon representing the task type
              Icon(icon, size: 36.0, color: Colors.black),
              const SizedBox(width: 16.0), // Spacing between icon and text
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
                      style: GlobalFont.bigfontRBold,
                    ),

                    // The secondary info (time)
                    Text(
                      'Pukul $time',
                      style: GlobalFont.bigfontRBold.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
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
                      style: GlobalFont.bigfontR,
                    ),
                  ),

                  // The "Delete" option in the menu
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(
                      'Hapus',
                      style: GlobalFont.bigfontR,
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
