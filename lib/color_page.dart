/// Color page
///
/// Page that allows user to select any of the givens colors
/// as the primary color for the app theme

import 'package:flutter/material.dart';

import 'Helpers.dart';
import 'ProfilePage.dart';
import 'app_user.dart';

class ColorPage extends StatefulWidget {
  const ColorPage({Key? key}) : super(key: key);


  @override
  _ColorPageState createState() => _ColorPageState();
}

AppUser user = AppUser();


class _ColorPageState extends State<ColorPage>{

  /// creates the row of colors
  ///
  /// returns a Row object containing 4 buttons with different squares
  /// the order of the buttons is determined by the values passed in through order
  /// ```dart
  /// letters = [A, B, C, D]
  /// order = [2, 1, 0, 3]
  /// letters = [C, B, A, D]
  /// ```
  Row colorRow({List<Color?> colors = const [] , List<String> colorsStr = const [], List<int> order = const []}) {
    List<Widget> widgets = [];
    for (int i = 0; i < 4; i ++) {
      if (colorsStr[order[i]] == AppUser.getColorStr()) {
        widgets.add(
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              width : 70,
              height : 90,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    AppUser.setColor(colorsStr[order[i]]);
                  });
                }, // edit color
                child: const Text(""),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(colors[order[i]]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: const BorderSide(
                        color: Colors.white,
                        width : 1.5,
                          ),
                        ),
                    ),
                ),
              ),
            ),
        );
      } else {
        widgets.add(
            Container(
              width : 70,
              height : 90,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    AppUser.setColor(colorsStr[order[i]]);
                  });
                }, // edit color
                child: const Text(""),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(colors[order[i]]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )
                    )
                ),
              ),
            )
        );
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (dis) {
        if (dis.delta.dx > 0) {
          Navigator.push(context, SlideLeftRoute(page: const ProfilePage()));
        } else if (dis.delta.dx < 0) {
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "Weedipedia",
            style: style(color: AppUser.getColor(), fontSize: 35, fontFamily: 'LinuxLibertine'),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              // Navigator.pop(context);
            },
            color: AppUser.getColor(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), color: Colors.black,),
              colorRow(colors: [Colors.red[400], Colors.red, Colors.redAccent[700], Colors.red[600]],
                  colorsStr: ["red400", "red","redAccent700", "red600"],
                  order : [2, 3, 1, 0]),
              colorRow(colors: [Colors.pink[300], Colors.pinkAccent[700], Colors.pink[600], Colors.pink[800]],
                  colorsStr: ["pink300", "pinkAccent700", "pink600", "pink800"],
                  order : [0, 2, 1, 3]),
              colorRow(colors: [Colors.purple[800], Colors.purple, Colors.purple[300], Colors.purpleAccent[100]],
                  colorsStr: ["purple800", "purple", "purple300", "purpleAccent100"],
                  order : [0, 1, 2, 3]),
              colorRow(colors: [Colors.deepPurple[300], Colors.deepPurple, Colors.deepPurpleAccent[700], Colors.deepPurpleAccent[400]],
                  colorsStr: ["deepPurple300", "deepPurple", "deepPurpleAccent700", "deepPurpleAccent400"],
                  order : [0, 1, 2, 3]),
              colorRow(colors: [Colors.indigoAccent[400], Colors.indigoAccent[100], Colors.indigo[400], Colors.indigo[700]],
                  colorsStr: ["indigoAccent400", "indigoAccent100", "indigo400", "indigo700"],
                  order : [0, 1, 2, 3]),
              colorRow(colors: [Colors.blue[900], Colors.blue[700], Colors.blue, Colors.blue[300]],
                  colorsStr: ["blue900", "blue700", "blue", "blue300"],
                  order : [0, 1, 2, 3]),
              colorRow(colors: [Colors.cyan[200], Colors.cyan[400], Colors.cyanAccent[400], Colors.cyanAccent],
                  colorsStr: ["cyan200", "cyan400", "cyanAccent400", "cyan"],
                  order : [0, 1, 2, 3]),
              colorRow(colors: [Colors.tealAccent, Colors.greenAccent, Colors.greenAccent[400], Colors.greenAccent[700]],
                  colorsStr: ["tealAccent", "greenAccent", "greenAccent400", "greenAccent700"],
                  order : [0, 1, 2, 3]),
              colorRow(colors: [Colors.lightGreenAccent[700], Colors.lightGreenAccent[400], Colors.lightGreenAccent, Colors.lightGreenAccent[100]],
                  colorsStr: ["lightGreenAccent700", "lightGreenAccent400", "lightGreenAccent", "lightGreenAccent100"],
                  order : [0, 1, 2, 3]),
              colorRow(colors: [Colors.limeAccent[700], Colors.limeAccent[400], Colors.limeAccent, Colors.limeAccent[100]],
                  colorsStr: ["limeAccent700", "limeAccent400", "limeAccent", "limeAccent100"],
                  order : [0, 1, 2, 3]),
              colorRow(colors: [Colors.yellow[700], Colors.yellow[400], Colors.yellow, Colors.yellow[100]],
                  colorsStr: ["yellow700", "yellow400", "yellow", "yellow100"],
                  order : [3, 2, 1, 0]),
              colorRow(colors: [Colors.amberAccent[700], Colors.amberAccent[400], Colors.amberAccent, Colors.amberAccent[100]],
                  colorsStr: ["amberAccent700", "amberAccent400", "amberAccent", "amberAccent100"],
                  order : [0, 1, 2, 3]),
              colorRow(colors: [Colors.orangeAccent[700], Colors.orangeAccent[400], Colors.orangeAccent, Colors.orangeAccent[100]],
                  colorsStr: ["orangeAccent700", "orangeAccent400", "orangeAccent", "orangeAccent100"],
                  order : [3, 2, 1, 0]),
              colorRow(colors: [Colors.deepOrangeAccent[700], Colors.deepOrangeAccent[400], Colors.deepOrangeAccent, Colors.deepOrangeAccent[100]],
                  colorsStr: ["deepOrangeAccent700", "deepOrangeAccent400", "deepOrangeAccent", "deepOrangeAccent100"],
                  order : [0, 1, 2, 3]),
            ],
          ),
        ),
      ),
    );
  }
}