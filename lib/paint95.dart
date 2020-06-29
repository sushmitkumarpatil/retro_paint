/*
TODO
1. Free Line
2. Clear -- Done
3. Eraser -- Done 
4. Undo -- Done
5. Circle -- Done
6. Box -- Done
7. Save to Image -- Pending 
*/
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
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
  List<enumToolTypes> drawHistory = List();
  bool isCanvasLocked = false;
  bool saveClicked = false;

  List<PaintedSquires> squaresList = List();
  PaintedSquires unfinishedSquare;

  List<PaintedCircles> circleList = List();
  PaintedCircles unfinishedCircle;

  StrokeCap strokeType = StrokeCap.square;
  double strokeWidth = 3.0;

  Color selectedColor = Colors.black;
  List<ToolIconsData> lstToolIcons = [
    ToolIconsData(Icons.create, enumToolTypes.pencil, isSelected: true),
    ToolIconsData(FontAwesomeIcons.eraser, enumToolTypes.eraser),
    ToolIconsData(Icons.crop_square, enumToolTypes.rectangle),
    ToolIconsData(Icons.radio_button_unchecked, enumToolTypes.circle),
    //ToolIconsData(Icons.text_fields, enumToolTypes.text), //TODO
  ];

  Paint getPoint() {
    if (selectedTool == enumToolTypes.eraser) {
      return Paint()
        ..strokeCap = strokeType
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..color = Colors.white;
    } else {
      return Paint()
        ..strokeCap = strokeType
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..color = selectedColor;
    }
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        saveClicked = true;
                      });
                    },
                    child: MenuItem("Save"),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (drawHistory.length > 0) {
                          enumToolTypes lastAction = drawHistory.last;
                          if (lastAction == enumToolTypes.eraser ||
                              lastAction == enumToolTypes.pencil) {
                            if (paintedPoints.length > 0) {
                              RecordPaints lastPoint = paintedPoints.last;

                              if (lastPoint.endIndex != null)
                                pointsList.removeRange(
                                    lastPoint.startIndex, lastPoint.endIndex);
                              paintedPoints.removeLast();
                            }
                          } else if (lastAction == enumToolTypes.rectangle) {
                            squaresList.removeLast();
                          } else {
                            circleList.removeLast();
                          }
                          drawHistory.removeLast();
                        }
                        //pointsListDeleted.;
                      });
                    },
                    child: MenuItem("Undo"),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        pointsList.clear();
                        paintedPoints.clear();
                        squaresList.clear();
                        circleList.clear();
                      });
                    },
                    child: MenuItem("Clear"),
                  ),
                  GestureDetector(
                    onTap: () {
                      myDialog();
                      //exit(0);
                    },
                    child: MenuItem("Exit"),
                  ),
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
                        Container(
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
                              if (isCanvasLocked) return;
                              setState(() {
                                RenderBox renderBox =
                                    context.findRenderObject();
                                if (selectedTool == enumToolTypes.pencil ||
                                    selectedTool == enumToolTypes.eraser) {
                                  pointsList.add(
                                    PaintedPoints(
                                      points: renderBox.globalToLocal(
                                          details.globalPosition),
                                      paint: getPoint(),
                                    ),
                                  );
                                } else if (selectedTool ==
                                    enumToolTypes.rectangle) {
                                  unfinishedSquare.end = renderBox
                                      .globalToLocal(details.globalPosition);
                                } else if (selectedTool ==
                                    enumToolTypes.circle) {
                                  unfinishedCircle.end = renderBox
                                      .globalToLocal(details.globalPosition);
                                }
                              });
                            },
                            onPanStart: (details) {
                              if (isCanvasLocked) return;
                              setState(() {
                                RenderBox renderBox =
                                    context.findRenderObject();
                                if (selectedTool == enumToolTypes.pencil ||
                                    selectedTool == enumToolTypes.eraser) {
                                  if (pointsList.length > 0) {
                                    paintedPoints.add(
                                        RecordPaints(pointsList.length, null));
                                  } else
                                    paintedPoints.add(RecordPaints(0, null));

                                  pointsList.add(
                                    PaintedPoints(
                                      points: renderBox.globalToLocal(
                                          details.globalPosition),
                                      paint: getPoint(),
                                    ),
                                  );
                                } else if (selectedTool ==
                                    enumToolTypes.rectangle) {
                                  unfinishedSquare = PaintedSquires();
                                  Offset os = renderBox
                                      .globalToLocal(details.globalPosition);
                                  unfinishedSquare.start = os;
                                  unfinishedSquare.end = os;
                                  unfinishedSquare.paint = getPoint();
                                } else if (selectedTool ==
                                    enumToolTypes.circle) {
                                  unfinishedCircle = PaintedCircles();
                                  Offset os = renderBox
                                      .globalToLocal(details.globalPosition);
                                  unfinishedCircle.start = os;
                                  unfinishedCircle.end = os;
                                  unfinishedCircle.paint = getPoint();
                                }
                              });
                            },
                            onPanEnd: (details) {
                              if (isCanvasLocked) return;
                              setState(() {
                                drawHistory.add(selectedTool);
                                if (selectedTool == enumToolTypes.pencil ||
                                    selectedTool == enumToolTypes.eraser) {
                                  paintedPoints
                                      .firstWhere(
                                          (element) => element.endIndex == null)
                                      .endIndex = pointsList.length;
                                  pointsList.add(null);
                                } else if (selectedTool ==
                                    enumToolTypes.rectangle) {
                                  setState(() {
                                    squaresList.add(unfinishedSquare);
                                    unfinishedSquare = null;
                                  });
                                } else if (selectedTool ==
                                    enumToolTypes.circle) {
                                  setState(() {
                                    circleList.add(unfinishedCircle);
                                    unfinishedCircle = null;
                                  });
                                }
                              });
                            },
                            child: ClipRect(
                              child: Container(
                                //Canvas
                                color: Colors.white,
                                //margin: EdgeInsets.only(bottom: 50, right: 80),
                                child: CustomPaint(
                                  size: Size(
                                      constraints.widthConstraints().maxWidth,
                                      constraints
                                          .heightConstraints()
                                          .maxHeight),
                                  painter: PainterCanvas(
                                    pointsList: pointsList,
                                    squaresList: squaresList,
                                    circlesList: circleList,
                                    unfinishedSquare: unfinishedSquare,
                                    unfinishedCircle: unfinishedCircle,
                                    saveImage: saveClicked,
                                    saveCallback: (Picture picture) async {
                                      var status =
                                          await Permission.storage.status;
                                      if (!status.isGranted) {
                                        await Permission.storage.request();
                                      }
                                      if (status.isGranted) {
                                        final img = await picture.toImage(
                                            constraints.maxWidth.round(),
                                            constraints.maxHeight.round());
                                        final bytes = await img.toByteData(
                                            format: ImageByteFormat.png);
                                        await ImageGallerySaver.saveImage(
                                          Uint8List.fromList(
                                              bytes.buffer.asUint8List()),
                                          quality: 100,
                                          name:
                                              DateTime.now().toIso8601String(),
                                        );
                                        showToastMessage(
                                            "Image saved to gallery.");
                                      }
                                      setState(() {
                                        saveClicked = false;
                                      });
                                    },
                                  ),
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
                      children: getColorBoxes(),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      tooltip: isCanvasLocked
                          ? "Click to unlock drawing"
                          : "Click to lock drawing",
                      icon: Icon(
                        isCanvasLocked ? Icons.lock_outline : Icons.lock_open,
                      ),
                      onPressed: () {
                        setState(() {
                          isCanvasLocked = !isCanvasLocked;
                        });
                      })
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
                    "Thanks for using our application. Please share your feedback.",
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

  myDialog() {
    Color buttonColor = const Color(0xFFc0c0c0);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: 400,
                height: 150,
                padding: EdgeInsets.all(2),
                color: Color(0xFFc0c0c0),
                child: Column(children: <Widget>[
                  Container(
                    height: 30,
                    color: Colors.indigo[900],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 10),
                        Text("Alert",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: "Arial")),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: ButtonTheme(
                              buttonColor: buttonColor,
                              shape: Border.all(
                                width: 1,
                                color: Color(0xFFa1a1a1),
                              ),
                              minWidth: 10,
                              height: 25,
                              child: RaisedButton(
                                child: Text("X",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () => {Navigator.pop(context, true)},
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text("Are you sure want to close application?",
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ButtonTheme(
                        buttonColor: buttonColor,
                        shape: Border.all(
                          width: 1,
                          color: Color(0xFFa1a1a1),
                        ),
                        child: RaisedButton(
                          child: Text("Yes",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => {exit(0)},
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ButtonTheme(
                        buttonColor: buttonColor,
                        shape: Border.all(
                          width: 1,
                          color: Color(0xFFa1a1a1),
                        ),
                        child: RaisedButton(
                          child: Text("No",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => {Navigator.pop(context, true)},
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        });
  }

  List<Widget> getColorBoxes() {
    return [
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
    ];
  }
}

class RecordPaints {
  int startIndex;
  int endIndex;
  RecordPaints(this.startIndex, this.endIndex);
}
