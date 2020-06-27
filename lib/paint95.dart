import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'widgets/menu-items.dart';
import 'widgets/tool-icons.dart';

class ClassicPaint extends StatefulWidget {
  @override
  _ClassicPaintState createState() => _ClassicPaintState();
}

class _ClassicPaintState extends State<ClassicPaint> {
  PainterController _controller;
  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.green;
    return controller;
  }

  Color selectedColor = Colors.black;
  List<ToolIconsData> lstToolIcons = [
    ToolIconsData(Icons.star_border, isSelected: true),
    ToolIconsData(Icons.check_box_outline_blank),
    ToolIconsData(Icons.leak_remove),
    ToolIconsData(Icons.format_paint),
    ToolIconsData(Icons.colorize),
    ToolIconsData(Icons.brush),
    ToolIconsData(Icons.gesture),
    ToolIconsData(Icons.text_fields),
    ToolIconsData(Icons.swap_horiz),
    ToolIconsData(Icons.swap_calls),
    ToolIconsData(Icons.crop_square),
    ToolIconsData(Icons.forward),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC0C0C0),
      body: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
              vertical: BorderSide(color: Colors.black54, width: 6)),
        ),
        padding: EdgeInsets.only(top: 3, bottom: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  MenuItem("File"),
                  MenuItem("Edit"),
                  MenuItem("View"),
                  MenuItem("Image"),
                  MenuItem("Colors"),
                  MenuItem("Help"),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Color(0xFFC0C0C0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Wrap(
                        children: getToolBoxIcons(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                        child: Expanded(
                          child: Container(
                            //Canvas
                            color: Colors.white,
                            margin: EdgeInsets.only(bottom: 50, right: 80),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              color: Color(0xFFC0C0C0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.black12,
                    padding:
                        EdgeInsets.only(top: 3, left: 3, right: 8, bottom: 8),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 5),
                          color: selectedColor,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 350,
                    child: Wrap(
                      children: <Widget>[
                        colorBox(Color.fromRGBO(0, 0, 0, 1)),
                        colorBox(Color.fromRGBO(125, 125, 125, 1)),
                        colorBox(Color.fromRGBO(120, 0, 0, 1)),
                        colorBox(Color.fromRGBO(120, 120, 0, 1)),
                        colorBox(Color.fromRGBO(0, 120, 0, 1)),
                        colorBox(Color.fromRGBO(0, 0, 120, 1)),
                        colorBox(Color.fromRGBO(120, 0, 120, 1)),
                        colorBox(Color.fromRGBO(120, 120, 60, 1)),
                        colorBox(Color.fromRGBO(0, 120, 60, 1)),
                        colorBox(Color.fromRGBO(0, 60, 120, 1)),
                        colorBox(Color.fromRGBO(0, 60, 60, 1)),
                        colorBox(Color.fromRGBO(60, 120, 120, 1)),
                        colorBox(Color.fromRGBO(60, 60, 120, 1)),
                        colorBox(Color.fromRGBO(120, 60, 30, 1)),
                        //Second Row
                        colorBox(Color.fromRGBO(255, 255, 255, 1)),
                        colorBox(Color.fromRGBO(190, 190, 190, 1)),
                        colorBox(Color.fromRGBO(255, 0, 0, 1)),
                        colorBox(Color.fromRGBO(255, 255, 0, 1)),
                        colorBox(Color.fromRGBO(0, 255, 0, 1)),
                        colorBox(Color.fromRGBO(0, 0, 255, 1)),
                        colorBox(Color.fromRGBO(255, 0, 255, 1)),
                        colorBox(Color.fromRGBO(255, 255, 120, 1)),
                        colorBox(Color.fromRGBO(0, 255, 120, 1)),
                        colorBox(Color.fromRGBO(0, 120, 255, 1)),
                        colorBox(Color.fromRGBO(0, 120, 120, 1)),
                        colorBox(Color.fromRGBO(120, 255, 255, 1)),
                        colorBox(Color.fromRGBO(120, 120, 255, 1)),
                        colorBox(Color.fromRGBO(255, 120, 60, 1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.black26,
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.black26,
            ),
            SizedBox(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              width: double.maxFinite,
              color: Color(0xFFC0C0C0),
              child: Row(
                children: <Widget>[
                  Text(
                    "For Help, click Help Topics on the Help Menu.",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  Text(
                    "ಧನ್ಯವಾದಗಳು (Thank You).",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getToolBoxIcons() {
    List<Widget> lstWidgets = List<Widget>();
    for (ToolIconsData item in lstToolIcons) {
      lstWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              lstToolIcons
                  .firstWhere((element) => element.isSelected == true)
                  .isSelected = false;
              lstToolIcons
                  .firstWhere((element) => element.icon == item.icon)
                  .isSelected = true;
            });
          },
          child: ToolIcon(
            item.icon,
            isActive: item.isSelected,
          ),
        ),
      );
    }
    return lstWidgets;
  }

  Widget colorBox(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          color: color,
        ),
        margin: EdgeInsets.all(2),
        width: 20,
        height: 20,
      ),
    );
  }
}

class ToolIconsData {
  IconData icon;
  bool isSelected;
  ToolIconsData(this.icon, {this.isSelected = false});
}
