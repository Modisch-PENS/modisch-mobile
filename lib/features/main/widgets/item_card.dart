import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final String image;
  final VoidCallback onTap;
  final bool draggable;
  final String? dragData;

  const ItemCard({
    super.key,
    required this.image,
    required this.onTap,
    this.draggable = false,
    this.dragData,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      transform:
          _isDragging ? (Matrix4.identity()..scale(1.1)) : Matrix4.identity(),
      decoration: BoxDecoration(
        boxShadow:
            _isDragging
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
                : [],
      ),
      // Di item_card.dart, ubah dekorasi Card:
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        color: Color(0xFFF9F9F9),
        child: Container(
          width: 160,
          height: 160,
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(widget.image),
        ),
      ),
    );

    if (widget.draggable) {
      return LongPressDraggable<String>(
        data: widget.dragData,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(widget.image),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.5, child: content),
        onDragStarted: () {
          setState(() {
            _isDragging = true;
          });
        },
        onDragEnd: (_) {
          setState(() {
            _isDragging = false;
          });
        },
        child: GestureDetector(
          onTap: widget.onTap, // ⬅️ supaya bisa klik walau draggable
          child: content,
        ),
      );
    } else {
      return GestureDetector(onTap: widget.onTap, child: content);
    }
  }
}
