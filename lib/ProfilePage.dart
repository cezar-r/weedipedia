/// Profile Page that stores the users saved strains and theme color settings

import 'package:flutter/material.dart';

import 'ConvertPage.dart';
import 'Helpers.dart';
import 'ResultPage.dart';
import 'app_user.dart';
import 'color_page.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 2;
  final List _saved = AppUser.getSaved();

  @override
  Widget build(BuildContext context) {

    /// navigates to page on navigation bar
    void _goToPage(int index) {
      if (index == _selectedIndex) {
        return;
      } else if (index == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
      } else if (index == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConvertPage()));
      }
      setState(() {
        _selectedIndex = index;
      });
    }

    /// builds the list of saved strains
    ///
    /// gets saved list from shared preferences and builds a list of ListTile's
    List<Widget> buildSavedList() {
      List<Widget> widgets = [];
      for (Map m in _saved.reversed) {
        widgets.add(
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(m['name'], [m], "Profile")));
              },
              title: Text(
                m['name'],
                style: style(color: AppUser.getColor(), fontSize: 14),
              ),
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: AppUser.getColor(),
                size: 20,
              ),
            ),
          ),
        );
      }
      return widgets;
    }

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
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ColorPage())); // goes to settings page
              },
              icon: const Icon(Icons.format_paint_rounded),
              color: Colors.white,
              iconSize: 25,
            ),
          ]
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Favorites",
                  style: style(fontSize: 30),
                ),
              ),
              Column(
                children: buildSavedList(),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        iconSize: 35,
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