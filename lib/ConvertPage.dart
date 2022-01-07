import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ProfilePage.dart';

import 'Constants.dart';
import 'Helpers.dart';
import 'app_user.dart';
import 'main.dart';

/// A class that represents a converter to convert different weight metrics
class Converter {
  String? _convertFrom = AppUser.getConvertFrom();
  String? _convertTo = AppUser.getConvertTo();
  String _convertedAmount = AppUser.getConvertedAmount();
  bool _converted = false;
  final TextEditingController _controllerFrom = TextEditingController();

  Converter();

  /// does the conversion
  void _convert() {
    String ogAmount = _controllerFrom.text;
    if (ogAmount == '') {
      ogAmount = AppUser.getOgAmount();
    }
    var _amount = int.parse(ogAmount);
    int mg = Constants.convertFrom[_convertFrom] * _amount;
    num displayAmount = mg / Constants.convertFrom[_convertTo];
    _converted = true;
    _convertedAmount = displayAmount.toStringAsFixed(2);
    AppUser.setConvertedAmount(_convertedAmount);
    AppUser.setOgAmount(ogAmount);
  }

  /// Returns a list of text widgets that describe the conversion
  /// "1000 milligrams is about 1 gram"
  List<Text> strRep() {
    List<Text> list = [];
    String ogAmount = AppUser.getOgAmount();

    list.add(Text(
      "$ogAmount $_convertFrom",
      style: style(color: AppUser.getColor(), fontSize: 18),
      overflow: TextOverflow.ellipsis,
    ));
    list.add(Text(
      " is about ",
      style: style(fontSize: 18),
      overflow: TextOverflow.ellipsis,
    ));
    list.add(Text(
        "$_convertedAmount $_convertTo",
        style: style(color: AppUser.getColor(), fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
    );

    return list;
  }
}

class ConvertPage extends StatefulWidget {
  const ConvertPage({Key? key}) : super(key: key);

  @override
  _ConvertPage createState() => _ConvertPage();
}

class _ConvertPage extends State<ConvertPage> {
  String firstHalf = '';
  String secondHalf = '';
  bool flag = true;

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 1;
  Converter c = Converter();

  @override
  Widget build(BuildContext context) {

    var _weights = ['milligrams', 'grams', 'eighths', 'quads', 'halves', 'ounces', 'kilograms', 'pounds'];

    /// builds the list of saved strains
    ///
    /// gets saved list from shared preferences and builds a list of ListTile's
    void _goToPage(int index) {
      if (index == _selectedIndex) {
        return;
      } else if (index == 0) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const Home(),
            transitionDuration: Duration.zero,
          ),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const ProfilePage(),
            transitionDuration: Duration.zero,
          ),
        );
      }
      setState(() {
        _selectedIndex = index;
      });
    }

    /// creates the picker
    ///
    /// picker is used to decide what metric the user wants to use when converting
    void showPicker(String from) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext builder) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text(''),
                      onPressed: () {},
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                    ),
                    CupertinoButton(
                      child: Text(
                        'Confirm',
                        style: TextStyle(color: AppUser.getColor()),
                      ),
                      onPressed: () {Navigator.of(context, rootNavigator: true).pop();},
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                    )
                  ],
                ),
                Container(
                  height: MediaQuery
                      .of(context)
                      .copyWith()
                      .size
                      .height * 0.25,
                  color: Colors.black,
                  child: CupertinoPicker(
                    children: _weights.map((x) => Text(x, style: style(fontSize: 18))).toList(),
                    onSelectedItemChanged: (value) {
                      Text text = Text(_weights[value], style: style(),);
                      if (from == 'from') {
                        c._convertFrom = text.data.toString();
                        c._convert();
                        AppUser.setConvertFrom(c._convertFrom!);
                      } else {
                        c._convertTo = text.data.toString();
                        c._convert();
                        AppUser.setConvertTo(c._convertTo!);
                      }
                      setState(() {

                      });
                    },
                    itemExtent: 50,
                    diameterRatio: 4,
                    useMagnifier: true,
                    magnification: 1.1,
                  )
              ),
            ]
            );
          }
      );
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onPanUpdate: (dis) {
        if (dis.delta.dx > 0) {
          Navigator.push(context, SlideLeftRoute(page: const Home()));
        } else if (dis.delta.dx < 0) {
          Navigator.push(context, SlideRightRoute(page: const ProfilePage()));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: Constants.appBar(),
        body: Container(
         padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            children: <Widget>[Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppUser.getColor()!,
                        width: 2
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    height: 100,
                    width: 150,
                    child: Column(
                      children: <Widget>[
                       TextField(
                            onChanged: (text) {
                              c._convert();
                              setState(() {
                              });
                            },
                            style: style(fontSize: 20),
                            controller: c._controllerFrom,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: AppUser.getOgAmount(),
                              hintStyle: style(color: Colors.grey[600], fontSize: 20),
                              fillColor: Colors.grey[900],
                              filled: true,
                              contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                              isDense: true,
                            ),
                          ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: 30,
                            width: 150,
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    AppUser.getConvertFrom(),
                                    style: style(fontSize: 14),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showPicker("from");
                                      },
                                      icon: Icon(
                                        Icons.arrow_drop_down_sharp,
                                        color: AppUser.getColor(),

                                      ),
                                  )
                                ]
                              ),
                              onPressed: (){
                                showPicker("from");
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "≈",
                  style: style(fontSize: 40),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppUser.getColor()!,
                          width: 2.5
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    height: 100,
                    width: 150,
                    child: Column(
                      children: <Widget>[
                          Container(
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            color: Colors.grey[900],
                            child : Align(
                              alignment: Alignment.centerLeft,
                              child: SelectableText(

                                  c._convertedAmount,
                                  style: style(color: c._converted ? Colors.white : Colors.grey[600], fontSize: 20),

                              ),
                            ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: 30,
                            width: 150,
                            child: ElevatedButton(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      AppUser.getConvertTo(),
                                      style: style(fontSize: 14),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showPicker("to");
                                      },
                                      icon: Icon(
                                        Icons.arrow_drop_down_sharp,
                                        color: AppUser.getColor(),
                                      ),
                                    )
                                  ]
                              ),
                              onPressed: (){
                                showPicker("to");
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40,),
            Wrap(
              children: c.strRep(),
              runSpacing: 5.0,
              spacing: 5.0,
            ),
          ]
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[900],
          iconSize: 35,
          // type: BottomNavigationBarType.shifting,
          items: Constants.navBarItems,
          selectedItemColor: AppUser.getColor(),
          currentIndex: _selectedIndex,
          onTap: _goToPage,
          selectedIconTheme: IconThemeData(color: AppUser.getColor(), size: 40),
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}