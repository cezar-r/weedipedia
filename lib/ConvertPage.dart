import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ProfilePage.dart';

import 'Constants.dart';
import 'Helpers.dart';
import 'app_user.dart';
import 'main.dart';

/// A class that represents a converter to convert different weight metrics
class Converter {
  String? _convertFrom = 'g';
  String? _convertTo = 'oz';
  String _convertedAmount = '0.99';
  bool _converted = false;
  final TextEditingController _controllerFrom = TextEditingController();

  Converter();

  void _convert() {
    if (_controllerFrom.text == '') {
      _controllerFrom.text = '28';
    }
    var _amount = int.parse(_controllerFrom.text);
    int mg = Constants.convertFrom[_convertFrom] * _amount;
    num displayAmount = mg / Constants.convertFrom[_convertTo];
    _converted = true;
    _convertedAmount = displayAmount.toStringAsFixed(2);
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

    var _weights = ['mg', 'g', '1/8', '1/4', '1/2', 'oz', 'kg', 'lb'];

    /// builds the list of saved strains
    ///
    /// gets saved list from shared preferences and builds a list of ListTile's
    void _goToPage(int index) {
      if (index == _selectedIndex) {
        return;
      } else if (index == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
      } else if (index == 2) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
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
                      } else {
                        c._convertTo = text.data.toString();
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
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: Constants.appBar(),
        body: Container(
         padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(120, 0, 120, 0),
                child: TextField(
                  style: style(fontSize: 18),
                  controller: c._controllerFrom,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: '28',
                    hintStyle: style(color: Colors.grey[600], fontSize: 16),
                    fillColor: Colors.grey[900],
                    filled: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                    isDense: true,
                  ),
                ),
              ),
              ElevatedButton(
                child: Text(
                    c._convertFrom!,
                    style: style(fontSize: 16),),
                onPressed: (){
                  showPicker("from");
                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: .5,
                    color: AppUser.getColor()!,
                  ),
                  primary: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color: AppUser.getColor(),
                  size: 50,
                ),
                // onPressed: c._convert,
                onPressed: (){
                  setState(() {
                    c._convert();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return AppUser.getColor()!;
                      return Colors.black;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(120, 0, 120, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  height : 40,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.grey[900],
                  ),
                  child : Text(
                    c._converted ? c._convertedAmount : "0.99",
                    style: style(color: c._converted ? Colors.white : Colors.grey[600], fontSize: 16),
                  ),
                ),
              ),
              ElevatedButton(
                child: Text(
                  c._convertTo!,
                  style: style(fontSize: 16),),
                onPressed: (){
                  showPicker("to");
                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: .5,
                    color: AppUser.getColor()!,
                  ),
                  primary: Colors.black,
                ),
              ),
            ],
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