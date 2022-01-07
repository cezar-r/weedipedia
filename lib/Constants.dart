import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Helpers.dart';
import 'app_user.dart';

/// hashmap of the color options and their string representations
class Constants {

  static List _data = [];

  static Map colorHashMap = {"black": Colors.black,
    "red400": Colors.red[400], "red": Colors.red, "red600": Colors.red[600], "redAccent700": Colors.redAccent[700],
    "pink300": Colors.pink[300], "pink600": Colors.pink[600], "pinkAccent700": Colors.pinkAccent[700], "pink800": Colors.pink[800],
    "purple800" : Colors.purple[800], "purple" : Colors.purple, "purple300" : Colors.purple[300], "purpleAccent100" : Colors.purpleAccent[100],
    "deepPurple300" : Colors.deepPurple[300], "deepPurple" : Colors.deepPurple, "deepPurpleAccent700" : Colors.deepPurpleAccent[700], "deepPurpleAccent400" : Colors.deepPurpleAccent[400],
    "indigoAccent400" : Colors.indigoAccent[400], "indigoAccent100" : Colors.indigoAccent[100], "indigo400" : Colors.indigo[400], "indigo700" : Colors.indigo[700],
    "blue900" : Colors.blue[900], "blue700" : Colors.blue[700], "blue" : Colors.blue, "blue300" : Colors.blue[300],
    "cyan200" : Colors.cyan[200], "cyan400" : Colors.cyan[400], "cyanAccent400" : Colors.cyanAccent[400], "cyan" : Colors.cyan,
    "tealAccent" : Colors.tealAccent, "greenAccent" : Colors.greenAccent, "greenAccent400" : Colors.greenAccent[400], "greenAccent700": Colors.greenAccent[700],
    "lightGreenAccent700" : Colors.lightGreenAccent[700], "lightGreenAccent400" : Colors.lightGreenAccent[400], "lightGreenAccent" : Colors.lightGreenAccent, "lightGreenAccent100": Colors.lightGreenAccent[100],
    "limeAccent700" : Colors.limeAccent[700], "limeAccent400" : Colors.limeAccent[400], "limeAccent" : Colors.limeAccent, "limeAccent100": Colors.limeAccent[100],
    "yellow700" : Colors.yellow[700], "yellow400" : Colors.yellow[400], "yellow" : Colors.yellow, "yellow100": Colors.yellow[100],
    "amberAccent700" : Colors.amberAccent[700], "amberAccent400" : Colors.amberAccent[400], "amberAccent" : Colors.amberAccent, "amberAccent100": Colors.amberAccent[100],
    "orangeAccent700" : Colors.orangeAccent[700], "orangeAccent400" : Colors.orangeAccent[400], "orangeAccent" : Colors.orangeAccent, "orangeAccent100": Colors.orangeAccent[100],
    "deepOrangeAccent700" : Colors.deepOrangeAccent[700], "deepOrangeAccent400" : Colors.deepOrangeAccent[400], "deepOrangeAccent" : Colors.deepOrangeAccent, "deepOrangeAccent100": Colors.deepOrangeAccent[100],
  };

  static Map convertFrom = {
    "milligrams" : 1,
    "grams" : 1000,
    "eighths" : 3544,
    "quads" : 7088,
    "halves" : 14175,
    "ounces" : 28350,
    "pounds" : 453592,
    "kilograms" : 1000000,
  };


  /// helper function that reads the JSON file that contains all the data
  static Future<List> readJsonHelper() async {
    final String response = await rootBundle.loadString('assets/data2_rfmtd.json');
    final data = await json.decode(response);
    return data['items'];
  }

  /// parent function that reads the JSON file
  static void readJson() async {
    List data = await readJsonHelper();
    _data = data;
  }

  /// returns strain data
  static List data() {
    if (_data.isEmpty) {
      readJson();
    }
    return _data;
  }

  static List<BottomNavigationBarItem> navBarItems = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.search_rounded),
      label: 'Search',

    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.sync_alt),
      label: 'Convert',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_rounded),
      label: 'Profile',
    ),
  ];


  static AppBar appBar() {
    return AppBar(
      title: Text(
        "Weedipedia",
        style: style(color: AppUser.getColor(), fontSize: 35, fontFamily: 'LinuxLibertine'),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
      elevation: 0.0,
      automaticallyImplyLeading: false,
    );
  }

}

