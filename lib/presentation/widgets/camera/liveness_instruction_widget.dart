import 'package:flutter/material.dart';

class LivenessInstructionWidget extends StatelessWidget {
  final String instruction;
  final bool faceDetected;
  final bool livenessOk;

  const LivenessInstructionWidget({
    super.key,
    required this.instruction,
    this.faceDetected = false,
    this.livenessOk = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _iconColor, size: 22),

          Flexible(
            child: Text(
              'Instruction: $instruction',
              style: TextStyle(
                color: _textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color get _backgroundColor {
    if (livenessOk) return Colors.green.shade50;
    if (faceDetected) return Colors.orange.shade50;
    return Colors.red.shade50;
  }

  Color get _iconColor {
    if (livenessOk) return Colors.green.shade700;
    if (faceDetected) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  Color get _textColor {
    if (livenessOk) return Colors.green.shade900;
    if (faceDetected) return Colors.orange.shade900;
    return Colors.red.shade900;
  }

  IconData get _icon {
    if (livenessOk) return Icons.check_circle_outline;
    if (faceDetected) return Icons.face;
    return Icons.face_retouching_off;
  }
}
