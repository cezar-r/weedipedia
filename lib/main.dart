/* TODO
Recent Searches
  Find way to only display when keyboard is first opened

Visuals TODO
DONE: Get rid of animations between screens
DONE: Make unfavorited heart slightly brighter
DONE: Convert Page
  DONE: Possibly restyle page (horizontal layout)
  DONE: Use equals sign instead of arrow
  DONE: Auto convert when weight is being typed
  DONE: Make metric button borders thicker
  DONE: When convertTo or convertFrom is edited, perform calculation
  DONE: Add sentence to converter page (1000 mg is about 1g)
DONE: Get rid of press animation on heart button
DONE: Swipe to navigate
  Animations
Loading Screen
*/
/// Home Screen Page

import 'dart:collection';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ProfilePage.dart';

import 'Constants.dart';
import 'ConvertPage.dart';
import 'Helpers.dart';
import 'ResultPage.dart';
import 'app_user.dart';


void main() {
  runApp(MaterialApp(
    home: const Home(),
    theme: ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    ),
  ));
}

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

/// Home Page of the application
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  /// all of the strain data
  List _data  = [];

  @override
  void initState() {
    super.initState();
    AppUser.init();
  }

  _HomePageState() {
    _data = Constants.data();
  }

  /// finds all strains that start with the letters passed in as String search
  ///
  /// function calls the lookup function which returns a list of data
  /// if list is empty, that means there is no data
  Future<List<Post>> search(String search) async {
    await Future.delayed(const Duration(milliseconds: 0));
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

  /// returns strains that start with the letters passed in as String name
  List<HashMap<String, String>> lookup(String name) {
    List<HashMap<String, String>> returnData = [];
    for (int i = 0; i < _data.length; i ++) {
      if (returnData.length > 30) {
        break;
      }
      HashMap<String, String> data = HashMap<String, String>();
      if (_data[i]['name'].toLowerCase().startsWith(name.toLowerCase())) {
        data.putIfAbsent('name', () => _data[i]['name']);
        data.putIfAbsent('strain_type', () => _data[i]['strain_type']);
      }
      if (data.isNotEmpty) {
        returnData.add(data);
      }
    }
    return returnData;
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    /// navigates to page on navigation bar
    void _goToPage(int index) {
      if (index == _selectedIndex) {
        return;
      } else if (index == 1) {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const ConvertPage()));
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const ConvertPage(),
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

    // /// generates a list of recent searches
    // List<Post> _getRecentSearches() {
    //   List<Post> tiles = [];
    //   List recents = AppUser.getRecent();
    //   for (String recent in recents.reversed) {
    //     tiles.add(Post(recent, ""));
    //   }
    //   return tiles;
    // }

    return GestureDetector(
      onVerticalDragDown: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      onPanUpdate: (dis) {
        if (dis.delta.dx > 0) {
          return; // can't go left from home page
        } else if (dis.delta.dx < 0) {
          Navigator.push(context, SlideRightRoute(page: const ConvertPage()));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: Constants.appBar(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SearchBar<Post>(
            // suggestions: _getRecentSearches(),
            searchBarPadding: EdgeInsets.zero,
            hintText:  "Search a strain",
            minimumChars: 1,
            debounceDuration: const Duration(milliseconds: 50),
            onSearch: search,
            onItemFound: (Post post, int index) {
              if (post.title == "No results") {
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                  alignment: Alignment.center,
                  child: Text(
                    "No results",
                    style: style(color: AppUser.getColor(), fontSize: 15),
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                  trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppUser.getColor(),
                  ),
                  onTap: () {
                    AppUser.addRecent(post.title);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(post.title, _data, "Home")));
                  },
                  title: Text(
                    post.title,
                    style: style(color: AppUser.getColor(), fontSize: 16),
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
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            cancellationText: Text(
              "Clear",
              style: style(color: Colors.grey, fontSize: 15)
            ),
            loader: Center(
              child: Text(
                "loading...",
                style: style(color: AppUser.getColor(), fontSize: 15)
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[900],
          iconSize: 35,
          items: Constants.navBarItems,
          selectedItemColor: AppUser.getColor(),
          currentIndex: _selectedIndex,
          onTap: _goToPage,
          selectedIconTheme: IconThemeData(color: AppUser.getColor(), size: 45),
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}