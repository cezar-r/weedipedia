/* TODO
Recent Searches
Saved list
  Save strains to a list
  Add save button to each strain
*/

/// Home Screen Page

import 'dart:collection';
import 'dart:convert';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Helpers.dart';
import 'ResultPage.dart';
import 'app_user.dart';
import 'color_page.dart';


void main() {
  //AppUser.init();
  runApp(const MaterialApp(
    home: Home()
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

  /// helper function that reads the JSON file that contains all the data
  Future<List> readJsonHelper() async {
    final String response = await rootBundle.loadString('assets/data2_rfmtd.json');
    final data = await json.decode(response);
    setState(() {
      _data = data["items"];
    });
    return data['items'];
  }

  /// parent function that reads the JSON file
  void readJson() async {
    List data = await readJsonHelper();
    _data = data;
  }

  _HomePageState() {
    readJson();
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



  @override
  Widget build(BuildContext context) {

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
        leading: IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ColorPage())); // goes to settings page
          },
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SearchBar<Post>(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(post.title, _data)));
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
    );
  }
}