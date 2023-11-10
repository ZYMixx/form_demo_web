import 'package:flutter/material.dart';

class MyDeleteIconButton extends StatefulWidget {
  const MyDeleteIconButton({
    Key? key,
    required this.size,
    required this.onSelect,
    required this.onDeselect,
  }) : super(key: key);
  final double size;
  final Function onSelect;
  final Function onDeselect;

  @override
  State<MyDeleteIconButton> createState() => _MyDeleteIconButtonState();
}

class _MyDeleteIconButtonState extends State<MyDeleteIconButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(
        Icons.delete_forever_sharp,
        size: widget.size,
        color: isSelected ? Colors.red : Colors.grey[700],
      ),
      onTap: () {
        setState(() {
          if (isSelected) {
            widget.onDeselect.call();
          } else {
            widget.onSelect.call();
          }
          isSelected = !isSelected;
        });
      },
    );
  }
}
