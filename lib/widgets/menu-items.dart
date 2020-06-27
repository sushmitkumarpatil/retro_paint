import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String itemName;
  MenuItem(this.itemName);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          child: Text(itemName),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
