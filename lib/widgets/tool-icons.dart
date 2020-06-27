import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToolIcon extends StatelessWidget {
  final IconData iconData;
  final bool isActive;
  ToolIcon(this.iconData, {this.isActive = false});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0.9,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      color: isActive ? Color(0x00C0C0C0) : Color(0xFFC0C0C0),
      child: Container(
        child: IconButton(icon: Icon(iconData), onPressed: null),
      ),
    );
  }
}
