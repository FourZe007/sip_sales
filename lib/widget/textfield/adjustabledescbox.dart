import 'package:flutter/material.dart';

class AdjustableDescBox extends StatefulWidget {
  const AdjustableDescBox(
    this.textController, {
    super.key,
  });

  final TextEditingController textController;

  @override
  State<AdjustableDescBox> createState() => _AdjustableDescBoxState();
}

class _AdjustableDescBoxState extends State<AdjustableDescBox> {
  double initialHeight = 175;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: initialHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Text input area
          Expanded(
            child: TextField(
              controller: widget.textController,
              maxLines: null, // Allows unlimited lines
              expands: true, // Expands to fill available space
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Type your description here...',
                border: InputBorder.none, // Hide default underline
                contentPadding: EdgeInsets.all(12.0),
              ),
            ),
          ),
          // Draggable handle to resize
          GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                // Adjust height based on drag (clamp min/max values)
                initialHeight = (initialHeight + details.delta.dy)
                    .clamp(100.0, 450.0); // Min 100, Max 450
              });
            },
            child: Container(
              height: 20.0,
              color: Colors.grey[200],
              child: const Center(
                child: Icon(
                  Icons.drag_handle,
                  size: 18.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
