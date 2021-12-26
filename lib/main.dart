/* TODO
Fix data
  - Reviews are missing the first word sometimes as well as have "Follow our newsletter"
  - Uppercase strain names that are lowercase (.title())
Try different backgrounds on the back page
Potentially add custom color theme page

Fix Python Interpreter

Testflight TODO
 */

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


void main() => runApp(MaterialApp(
  home: Home()
));

TextStyle style({Color? color = Colors.white,
  double fontSize = 12,
  FontWeight? fontWeight = FontWeight.bold,
  String? fontFamily = 'SegoeBold'}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
  );
}

// const List<Widget> _pages = <Widget>[
//   Home(),
//   Account(),
// ];


class GlobalColor {
  Color? color = Colors.purpleAccent; // create function that reads file

  GlobalColor();

  Color? getColor() {
    return color;
  }

  void setColor(Color? newColor) {
    color = newColor; // write to file
  }
}

Map _color_hash = {"greenAccent700" : Colors.greenAccent[700],
  "black" : Colors.black,
  "red400" : Colors.red[400],
  "red" : Colors.red,
  "red600" : Colors.red[600],
  "redAccent700" : Colors.redAccent[700],
  "pink300" : Colors.pink[300],
  "pink600" : Colors.pink[600],
  "pinkAccent700" : Colors.pinkAccent[700],
  "pink800" : Colors.pink[800]};


class AppUser {

  Color? themeColor = Colors.greenAccent[700];
  String themeColorStr = 'greenAccent700';
  String key = 'color';

  AppUser() {
    getColor();
  }

  void getColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    themeColorStr = prefs.getString(key) ?? 'greenAccent700';
    themeColor = getColorHelper(themeColorStr);
  }

  Color? getColorHelper(String key) {
    return _color_hash[key];
  }

  void setColor(String color) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, color);
    themeColorStr = color;
    themeColor = getColorHelper(themeColorStr);
    print('setting color');
    print(color);
  }

}

AppUser user = AppUser();


class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  List _data  = [];
  GlobalColor color = new GlobalColor();

  Future<List> readJsonHelper() async {
    final String response = await rootBundle.loadString('assets/data2_rfmtd.json');
    final data = await json.decode(response);
    setState(() {
      _data = data["items"];
    });
    return data['items'];
  }

  void readJson() async {
    List data = await readJsonHelper();
    _data = data;
  }

  _HomePageState() {
    readJson();
  }

  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(milliseconds: 0));
    List<HashMap<String, String>> result = lookup(search);
    if (result.isEmpty) {
      return List.generate(result.length + 1, (int index) {
        return Post(
          "No results",
          "",
        );
      });
    }
    return List.generate(result.length, (int index) {
      return Post(
        "${result[index]['name']}",
        "${result[index]['strain_type']}",
      );
    });
  }

  List<HashMap<String, String>> lookup(String name) {
    List<HashMap<String, String>> returnData = [];
    for (int i = 0; i < _data.length; i ++) {
      if (returnData.length > 30)
        break;
      HashMap<String, String> data = HashMap<String, String>();
      if (_data[i]['name'].toLowerCase().startsWith(name.toLowerCase())) {
        data.putIfAbsent('name', () => _data[i]['name']);
        data.putIfAbsent('strain_type', () => _data[i]['strain_type']);
      }
      if (data.isNotEmpty)
        returnData.add(data);
    }
    return returnData;
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Weedipedia",
          style: style(color: user.themeColor, fontSize: 35, fontFamily: 'LinuxLibertine'),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.settings_rounded),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ColorPage()));
          },
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SearchBar<Post>(
          searchBarPadding: EdgeInsets.zero,
          hintText:  "Search a strain",
          minimumChars: 1,
          debounceDuration: Duration(milliseconds: 50),
          onSearch: search,
          onItemFound: (Post post, int index) {
            if (post.title == "No results") {
              return Container(
                margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                alignment: Alignment.center,
                child: Container(
                  child: Text(
                    "No results",
                    style: style(color: user.themeColor, fontSize: 15),
                  ),
                ),
              );
            }
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(5, 0, 20, 0),
                trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: user.themeColor,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(post.title, _data)));
                },
                title: Text(
                  post.title,
                  style: style(color: user.themeColor, fontSize: 16),
                ),
                selectedTileColor: Colors.grey[900],
                subtitle: Text(
                  post.description,
                  style: style(),
                ),
              ),
            );
          },
          textStyle: style(fontSize: 15),
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          cancellationText: Text(
            "Clear",
            style: style(color: Colors.grey, fontSize: 15)
          ),
          // cancellationText: Text(""),
          loader: Center(
            child: Text(
              "loading...",
              style: style(color: user.themeColor, fontSize: 15)
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.black,
      //   selectedItemColor: user.themeColor,
      //   unselectedItemColor: Colors.grey[700],
      //   items : const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search'
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Account'
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: onItemTapped,
      // ),

    );
  }
}

class ResultPage extends StatefulWidget {
  // const ResultPage({Key? key}) : super(key: key);
  String name = '';
  List data = [];
  ResultPage(String name, List data) {
    this.name = name;
    this.data = data;
  }

  @override
  _ResultPageState createState() => _ResultPageState(name, data);
}

class _ResultPageState extends State<ResultPage> {
  Map<String, dynamic> _data = Map<String, dynamic>();
  String name = '';
  List data = [];

  GlobalColor color = new GlobalColor();

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      print('Could not launch $url');
    }
  }

  _ResultPageState(String name, List data) {
    lookup(name, data);
  }

  Container reviewContainer(String review) {
    return Container( // Review
      margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
                "Review",
                style: style(fontSize: 20, fontWeight: FontWeight.normal)
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: new DescriptionTextWidget(text: review),
          ),
        ],
      ),
    ); //Review
  }

  Container buildContainer(String title, String subject, {bool openLink = false}) {
    if (openLink) {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                  title,
                  style: style(fontSize: 20, fontWeight: FontWeight.normal)
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                    child: ElevatedButton(
                      onPressed: ()  {
                        launchURL(subject);
                      },
                      child: Text(
                          subject,
                          style: style(fontWeight: FontWeight.normal)
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
                        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(10, 10, 0, 15)),
                        alignment: AlignmentDirectional.centerStart,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    };
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: style(fontSize: 20, fontWeight: FontWeight.normal)
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  // width: 390,
                  margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    color: Colors.grey[900],
                  ),
                  child: SelectableText(
                    subject,
                    style: style(fontWeight: FontWeight.normal)
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container printTop(String text, double fontSize) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
      child: Text(
        text,
        style: style(fontSize: fontSize, fontWeight: FontWeight.normal)
      ),
    );
  }

  void lookup(String name, List data) {
    _data = lookupHelper(name, data);
  }

  Color? checkColor(String value) {
    if (value == '-')
      return Colors.white;
    else
      return user.themeColor;
  }

  Map<String, dynamic> lookupHelper(String name, List data) {
    for (int i = 0; i < data.length; i ++) {
      if (data[i]['name'] == name) {
        print("got here");
        Map<String, dynamic> newData = data[i];
        return newData;
      }
    }
    return Map<String, dynamic>();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Weedipedia",
          style: style(color: user.themeColor, fontSize: 35, fontFamily: 'LinuxLibertine')
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: user.themeColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            printTop("${_data['name']}", 25.0), // Name of strain
            printTop("${_data['strain_type']}", 18.0), // Type of strain
            printTop("${_data['strain_type_strength']}", 12.0), // Percent of type of strain
            Container(
              margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    // margin: EdgeInsets.
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      color: Colors.grey[900],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 7.0),
                          child: Text(
                            "THC",
                            style: style(fontSize: 25, fontWeight: FontWeight.normal)
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: Text(
                            "${_data['thc_pct']}",
                            style: style(fontSize: 18, color: checkColor("${_data['thc_pct']}"), fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      color: Colors.grey[900],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 7.0),
                          child: Text(
                            "CBD",
                            style: style(fontSize: 25, fontWeight: FontWeight.normal)
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: Text(
                            "${_data['cbd_pct']}",
                            style: style(fontSize: 18, color: checkColor("${_data['cbd_pct']}"), fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      color: Colors.grey[900],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 7.0),
                          child: Text(
                            "CBN",
                            style: style(fontSize: 25, fontWeight: FontWeight.normal)
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: Text(
                            "${_data['cbn_pct']}",
                            style: style(fontSize: 18, color: checkColor("${_data['cbn_pct']}"), fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ), // THC %'s
            reviewContainer("${_data['review']}"),
            buildContainer("Effects", "${_data['effects']}"), // Effects
            buildContainer("May Relieve", "${_data['reliefs']}"), //May Relieve
            buildContainer("Flavors", "${_data['flavors']}"), // Flavors
            buildContainer("Aromas", "${_data['aromas']}"),
            buildContainer("Source", "${_data['source']}", openLink: true), // Aromas
            Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0)
            ),
          ],
        ),
      ),

    );
  }

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}


class DescriptionTextWidget extends StatefulWidget {
  String text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf = '';
  String secondHalf = '';
  GlobalColor color = new GlobalColor();
  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 150) {
      firstHalf = widget.text.substring(0, 150);
      secondHalf = widget.text.substring(150, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: secondHalf.isEmpty
          ? SelectableText(
            firstHalf,
            style: style(fontWeight: FontWeight.normal),
          )
          : Column(
        children: <Widget>[
          SelectableText(
              flag ? (firstHalf + "...") : (firstHalf + secondHalf),
              style: style(fontWeight: FontWeight.normal),
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  flag ? "show more" : "show less",
                  style: style(color: user.themeColor),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
        ],
      ),
    );
  }
}


class ColorPage extends StatefulWidget {

  @override
  _ColorPageState createState() => _ColorPageState();
}







class _ColorPageState extends State<ColorPage>{
  Row colorRow({List<Color?> colors = const [] , List<String> colorsStr = const [], List<int> order = const []}) {
    List<Widget> widgets = [];
    for (int i = 0; i < 4; i ++) {
      widgets.add(
          ElevatedButton(
            onPressed: () {
              user.setColor(colorsStr[order[i]]);
              setState(() {});
            }, // edit color
            child: Text(""),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colors[order[i]])
            ),
          )
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            },
          color: user.themeColor,
          ),
        ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            colorRow(colors: [Colors.red[400], Colors.red, Colors.redAccent[700], Colors.red[600]],
                    colorsStr: ["red400", "red","redAccent700", "redAccent600"],
                    order : [2, 3, 1, 0]),
            colorRow(colors: [Colors.pink[300], Colors.pinkAccent[700], Colors.pink[600], Colors.pink[800]],
                    colorsStr: ["pink300", "pinkAccent700", "pink600", "pink800"],
                    order : [0, 2, 1, 3]),
            // colorRow(colors: [Colors.pink[400], Colors.pinkAccent, Colors.pinkAccent[400], Colors.pink[800]],
            //     colorsStr: ["pink400", "pinkAccent", "pinkAccent400", "pink800"]),
          ],
        ),
      ),
    );
  }
}



/*
Map _color_hash = {"greenAccent700" : Colors.greenAccent[700],
                    "black" : Colors.black,
                    "red400" : Colors.red[400],
                    "red" : Colors.red,
                    "redAccent400" : Colors.redAccent[400],
                    "redAccent700" : Colors.redAccent[700]};
 */