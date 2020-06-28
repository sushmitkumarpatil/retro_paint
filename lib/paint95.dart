/*
TODO
1. Free Line
2. Clear -- Done
3. Eraser 
4. Undo -- Done
5. Text
6. Box
*/
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/menu-items.dart';
import 'widgets/painter.dart';
import 'widgets/tool-icons.dart';

class ClassicPaint extends StatefulWidget {
  @override
  _ClassicPaintState createState() => _ClassicPaintState();
}

enum enumToolTypes { pencil, eraser, rectangle, circle, text }

class ToolIconsData {
  IconData icon;
  bool isSelected;
  enumToolTypes toolType;
  ToolIconsData(this.icon, this.toolType, {this.isSelected = false});
}

class _ClassicPaintState extends State<ClassicPaint> {
  List<PaintedPoints> pointsList = List();
  List<PaintedPoints> pointsListDeleted = List();
  List<RecordPaints> paintedPoints = List();
  enumToolTypes selectedTool = enumToolTypes.pencil;

  StrokeCap strokeType = StrokeCap.square;
  double strokeWidth = 3.0;

  Color selectedColor = Colors.black;
  List<ToolIconsData> lstToolIcons = [
    ToolIconsData(Icons.create, enumToolTypes.pencil, isSelected: true),
    ToolIconsData(FontAwesomeIcons.eraser, enumToolTypes.eraser),
    ToolIconsData(Icons.crop_square, enumToolTypes.rectangle),
    ToolIconsData(Icons.radio_button_unchecked, enumToolTypes.circle),
    ToolIconsData(Icons.text_fields, enumToolTypes.text),
  ];

  Paint getPoint() {
    if (selectedTool == enumToolTypes.pencil) {
      return Paint()
        ..strokeCap = strokeType
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..color = selectedColor;
    } else if (selectedTool == enumToolTypes.eraser) {
      return Paint()
        ..strokeCap = strokeType
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..color = Colors.white;
    }
  }

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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        //pointsListDeleted.;
                        if (paintedPoints.length > 0) {
                          RecordPaints lastPoint = paintedPoints.last;

                          if (lastPoint.endIndex != null)
                            pointsList.removeRange(
                                lastPoint.startIndex, lastPoint.endIndex);
                          paintedPoints.removeLast();
                        }
                      });
                    },
                    child: MenuItem("Undo"),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        pointsList.clear();
                        paintedPoints.clear();
                      });
                    },
                    child: MenuItem("Clear"),
                  ),
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
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Wrap(
                            children: getToolBoxIcons(),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: selectedTool == enumToolTypes.pencil
                              ? true
                              : selectedTool == enumToolTypes.eraser
                                  ? true
                                  : false,
                          child: Container(
                            width: 80,
                            height: 90,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                strokeWidthWidget(3),
                                strokeWidthWidget(5),
                                strokeWidthWidget(7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          width: constraints.widthConstraints().maxWidth,
                          height: constraints.heightConstraints().maxHeight,
                          color: Colors.black.withOpacity(0.7),
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                RenderBox renderBox =
                                    context.findRenderObject();
                                pointsList.add(
                                  PaintedPoints(
                                    points: renderBox
                                        .globalToLocal(details.globalPosition),
                                    paint: getPoint(),
                                  ),
                                );
                              });
                            },
                            onPanStart: (details) {
                              setState(() {
                                if (pointsList.length > 0) {
                                  paintedPoints.add(
                                      RecordPaints(pointsList.length, null));
                                } else
                                  paintedPoints.add(RecordPaints(0, null));
                                RenderBox renderBox =
                                    context.findRenderObject();
                                pointsList.add(
                                  PaintedPoints(
                                    points: renderBox
                                        .globalToLocal(details.globalPosition),
                                    paint: getPoint(),
                                  ),
                                );
                              });
                            },
                            onPanEnd: (details) {
                              setState(() {
                                paintedPoints
                                    .firstWhere(
                                        (element) => element.endIndex == null)
                                    .endIndex = pointsList.length;
                                pointsList.add(null);
                              });
                            },
                            child: Container(
                              //Canvas
                              color: Colors.white,
                              //margin: EdgeInsets.only(bottom: 50, right: 80),
                              child: CustomPaint(
                                size: Size(
                                    constraints.widthConstraints().maxWidth,
                                    constraints.heightConstraints().maxHeight),
                                painter: PainterCanvas(
                                  pointsList: pointsList,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
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
              selectedTool = item.toolType;
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

  Widget strokeWidthWidget(double width) {
    bool isSelected = strokeWidth == width ? true : false;
    return Container(
      padding: EdgeInsets.symmetric(vertical: (10 - width), horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(
            width: 1, color: isSelected ? Colors.black : Colors.grey),
      ),
      child: Material(
        elevation: isSelected ? 1 : 0,
        child: InkWell(
          onTap: () {
            setState(() {
              strokeWidth = width;
            });
          },
          child: Container(
            width: 50,
            height: width,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class RecordPaints {
  int startIndex;
  int endIndex;
  RecordPaints(this.startIndex, this.endIndex);
}
