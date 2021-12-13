/* TODO
Home page with search bar (have results appear while typing)
Load in data into flutter app
Connect search page with results page
Page that loads result
Connect results page with result
 */

import 'dart:collection';
import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
  home: Home()
));

Container buildContainer(String title, String subject) {
  return Container(
    margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'SegoeBold',
            ),
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
                child: Text(
                  subject,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: 'SegoeBold',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Container printTop(String text, double fontSize_) {
  return Container(
    margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize_,
        color: Colors.white,
        fontFamily: 'SegoeBold',
      ),
    ),
  );
}

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

  Future<List> readJsonHelper() async {
    final String response = await rootBundle.loadString('assets/data.json');
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
    await Future.delayed(Duration(milliseconds: 100));
    List<HashMap<String, String>> result = lookup(search);
    if (result.length == 0) {
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
      if (!data.isEmpty)
        returnData.add(data);
    }
    return returnData;
  }

  // const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Weedipedia",
          style: TextStyle(
            color: Colors.greenAccent[700],
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'LinuxLibertine',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SearchBar<Post>(
          searchBarPadding: EdgeInsets.zero,
          minimumChars: 1,
          debounceDuration: Duration(milliseconds: 100),
          placeHolder: Text(
            "Search a strain",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'SegoeBold',
            ),
          ),
          onSearch: search,
          onItemFound: (Post post, int index) {
            return ListTile(
              onTap: () {
                print(context.runtimeType);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(post.title, _data)));
              },
              title: Text(
                post.title,
                style: TextStyle(
                  color: Colors.greenAccent[700],
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SegoeBold',
                ),
              ),
              subtitle: Text(
                post.description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SegoeBold',
                ),
              ),
            );
          },
          //
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'SegoeBold',
          ),
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          cancellationText: Text(
            "Cancel",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'SegoeBold'
            ),
          ),
          // cancellationText: Text(""),
          loader: Center(
            child: Text(
              "loading...",
              style: TextStyle(
                  color: Colors.greenAccent[700],
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SegoeBold'
              ),
            ),
          ),
        ),
      ),
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

  _ResultPageState(String name, List data) {
    lookup(name, data);
  }

  void lookup(String name, List data) {
    _data = lookupHelper(name, data);
  }

  Color? checkColor(String value) {
    if (value == '-')
      return Colors.white;
    else
      return Colors.greenAccent[700];
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
    // lookup(this.name, this.data);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Weedipedia",
          style: TextStyle(
            color: Colors.greenAccent[700],
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'LinuxLibertine',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.greenAccent[700],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ElevatedButton(
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            //     ),
            //     child: Text(''),
            //     onPressed: () {
            //       Navigator.pop(context);
            //   },
            // ),
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
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontFamily: 'SegoeBold',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: Text(
                            "${_data['thc_pct']}",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: checkColor("${_data['thc_pct']}"),
                              fontFamily: 'SegoeBold',
                            ),
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
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontFamily: 'SegoeBold',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: Text(
                            "${_data['cbd_pct']}",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: checkColor("${_data['cbd_pct']}"),
                              fontFamily: 'SegoeBold',
                            ),
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
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontFamily: 'SegoeBold',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: Text(
                            "${_data['cbn_pct']}",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: checkColor("${_data['cbn_pct']}"),
                              fontFamily: 'SegoeBold',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ), // THC %'s
            Container( // Review
              margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Review",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'SegoeBold',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      "${_data['review']}",
                      // "A+ Wonder is an  indica dominant hybrid strain (80% indica/20% sativa) created through crossing the classic William's Wonder X Afghani #1 IBL strains. Best known for its super calming and tranquil high, A+ Wonder is perfect for the patient who wants to reflect on their day in a perfectly happy state before finally falling asleep. It starts with a relaxing cerebral lift, filling your mind with a lightly buzzing sense of uplifted euphoria that adds a touch of creativity to your mental state, too. This sense of relaxation will soon spread its warming tendrils throughout the rest of your body, lulling you into a peaceful state of deep relaxation and ease that quickly turns sedative and sleepy. Thanks to these long-lasting effects and its moderately high 14-18% average THC level, A+ Wonder is often chosen to treat conditions such as chronic pain, mood swings or depression, insomnia and muscle spasms or cramps. This bud has a sour yet sweet fruity citrus flavor with a ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'SegoeBold',
                        wordSpacing: .01,
                      ),
                    ),
                  ),
                ],
              ),
            ), //Review
            buildContainer("Effects", "${_data['effects']}"), // Effects
            buildContainer("May Relieve", "${_data['reliefs']}"), //May Relieve
            buildContainer("Flavors", "${_data['flavors']}"), // Flavors
            buildContainer("Aromas", "${_data['aromas']}"), // Aromas
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
    // TODO: implement createState
    throw UnimplementedError();
  }

}