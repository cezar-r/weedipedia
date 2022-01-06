/// Result page that displays the results of the strain searched up

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DescriptionTextWidget.dart';
import 'Helpers.dart';
import 'ProfilePage.dart';
import 'app_user.dart';


class ResultPage extends StatefulWidget {
  // const ResultPage({Key? key}) : super(key: key);
  String name = '';
  List data = [];
  String fromPage = '';

  ResultPage(this.name, this.data, this.fromPage, {Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState(name, data, fromPage);
}

class _ResultPageState extends State<ResultPage> {
  Map<String, dynamic> _data = <String, dynamic>{};
  String name = '';
  List data = [];
  String fromPage = '';

  _ResultPageState(String name, List data, this.fromPage) {
    lookup(name, data);
  }

  /// method that opens a url
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    }
  }

  /// returns a container
  /// mainly used to format the strain name, strain type, and strain type strength
  Container printTop(String text, double fontSize) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
      child: Text(
          text,
          style: style(fontSize: fontSize, fontWeight: FontWeight.normal)
      ),
    );
  }

  /// returns a container object
  /// mainly used to format the review text
  Container reviewContainer(String review) {
    return Container( // Review
      margin: const EdgeInsets.fromLTRB(10, 30, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Review",
              style: style(fontSize: 20, fontWeight: FontWeight.normal)
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: ReviewText(text: review),
          ),
        ],
      ),
    ); //Review
  }

  /// returns a container object
  /// mainly used to format the effects part of the results
  Container buildContainer(String title, String subject, {bool openLink = false}) {
    if (openLink) {
      return Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                title,
                style: style(fontSize: 20, fontWeight: FontWeight.normal)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 10, 0),
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
                        padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(10, 10, 0, 15)),
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
    } else {
      return Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                title,
                style: style(fontSize: 20, fontWeight: FontWeight.normal)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    // width: 390,
                    margin: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 15),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(6.0)),
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
  }

  /// returns data for the given strain
  void lookup(String name, List data) {
    _data = lookupHelper(name, data);
  }

  /// helper function that looks for the data of the given strain
  Map<String, dynamic> lookupHelper(String name, List data) {
    for (int i = 0; i < data.length; i ++) {
      if (data[i]['name'] == name) {
        Map<String, dynamic> newData = data[i];
        return newData;
      }
    }
    return <String, dynamic>{};
  }

  /// method that checks for the color of the %'s
  Color? checkColor(String value) {
    if (value == '-') {
      return Colors.white;
    } else {
      return AppUser.getColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
            "Weedipedia",
            style: style(color: AppUser.getColor(), fontSize: 35, fontFamily: 'LinuxLibertine')
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (fromPage == 'Home') {
              Navigator.pop(context);
            } else if (fromPage == 'Profile') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
            }
          },
          color: AppUser.getColor(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    printTop("${_data['name']}", 25.0), // Name of strain
                    printTop("${_data['strain_type']}", 18.0), // Type of strain
                    printTop("${_data['strain_type_strength']}", 12.0), // Percent of type of strain
                  ],
                ),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (AppUser.savedContains(_data)) {
                            AppUser.removeSaved(_data);
                          } else {
                            AppUser.addSaved(_data);
                          }
                        });
                      },
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 35,
                        color: AppUser.savedContains(_data) ? AppUser.getColor() : Colors.grey[900],
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black)
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
            // printTop("${_data['name']}", 25.0), // Name of strain
            // printTop("${_data['strain_type']}", 18.0), // Type of strain
            // printTop("${_data['strain_type_strength']}", 12.0), // Percent of type of strain
            Container(
              margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    // margin: EdgeInsets.
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                      color: Colors.grey[900],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 7.0),
                          child: Text(
                              "THC",
                              style: style(fontSize: 25, fontWeight: FontWeight.normal)
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
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
                      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                      color: Colors.grey[900],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 7.0),
                          child: Text(
                              "CBD",
                              style: style(fontSize: 25, fontWeight: FontWeight.normal)
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
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
                      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                      color: Colors.grey[900],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 7.0),
                          child: Text(
                              "CBN",
                              style: style(fontSize: 25, fontWeight: FontWeight.normal)
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
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
            ),
            reviewContainer("${_data['review']}"),
            buildContainer("Effects", "${_data['effects']}"), // Effects
            buildContainer("May Relieve", "${_data['reliefs']}"), //May Relieve
            buildContainer("Flavors", "${_data['flavors']}"), // Flavors
            buildContainer("Aromas", "${_data['aromas']}"),
            buildContainer("Source", "${_data['source']}", openLink: true), // Aromas
            Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0)
            ),
          ],
        ),
      ),

    );
  }

  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}