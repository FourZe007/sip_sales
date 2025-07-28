import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';

class SalesDashboard extends StatelessWidget {
  final String title;
  final String data1;
  final String data2;
  final String percentage;
  final IconData trendIcon;
  final Color trendColor;

  const SalesDashboard({
    required this.title,
    required this.data1,
    required this.data2,
    required this.percentage,
    required this.trendIcon,
    required this.trendColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Adjust width as needed
      width: MediaQuery.of(context).size.width * 0.28,
      // Fixed height for simplicity
      // height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        // border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Diagonal Divider
          CustomPaint(
            size: Size.infinite,
            painter: DiagonalPainter(),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.fromLTRB(6, 0, 6, 4),
            child: Column(
              children: [
                // ~:Dashboard Title:~
                Text(
                  title,
                  style: GlobalFont.bigfontRBold,
                ),

                // ~:Dashboard Body:~
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data1,
                            style: GlobalFont.mediumgiantfontRBold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Icon(
                                trendIcon,
                                color: trendColor,
                                size: 24,
                              ),
                              Text(
                                '$percentage%',
                                style: GlobalFont.mediumbigfontRBold,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            data2,
                            style: GlobalFont.mediumgiantfontRBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Diagonal Divider
class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[300]!
      ..style = PaintingStyle.fill;

    final Path path = Path()
      // Start at the top-left corner, offset by the radius
      ..moveTo(20, 0) // 20 is the radius of the corner
      // Draw a curve for the rounded corner
      // Control point and end point
      ..quadraticBezierTo(0, 0, 0, 20)
      // Continue drawing the rest of the shape
      ..lineTo(0, size.height) // Bottom-left corner
      ..lineTo(size.width, 0) // Top-right corner
      ..close(); // Close the path to form a complete shape

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
