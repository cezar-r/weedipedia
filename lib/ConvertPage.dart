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

    var _weights = ['mg', 'g', '1/8', '1/4', '1/2', 'oz', 'kg', 'lb'];


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Weedipedia",
          style: style(color: AppUser.getColor(), fontSize: 35, fontFamily: 'LinuxLibertine'),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
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
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                hint: const Text('Amount'),
                iconEnabledColor: AppUser.getColor(),
                style: style(fontSize: 16),
                dropdownColor: Colors.black,
                value: c._convertFrom,
                onChanged: (String? newValue) {
                  c._convertFrom = newValue;
                    // state.didChange(newValue);
                },
                items: _weights.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(130, 10, 120, 10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Icon(
                Icons.swap_vert_rounded,
                color: AppUser.getColor(),
                size: 70,
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
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                hint: const Text('Amount'),
                iconEnabledColor: AppUser.getColor(),
                style: style(fontSize: 16),
                dropdownColor: Colors.black,
                value: c._convertTo,
                isDense: true,
                onChanged: (String? newValue) {
                    c._convertTo = newValue;
                },
                items: _weights.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(130, 10, 120, 10),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        iconSize: 35,
        // type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_alt),
            label: 'Convert',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
        selectedItemColor: AppUser.getColor(),
        currentIndex: _selectedIndex,
        onTap: _goToPage,
        selectedIconTheme: IconThemeData(color: AppUser.getColor(), size: 40),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}