// import 'package:flutter/material.dart';
// import 'Helpers.dart';
// import 'app_user.dart';
// import 'main.dart';
//
// const List<Widget> pages = <Widget>[
//   Home(),
//   Icon(Icons.sync_alt),
// ];
//
//
// class Navbar {
//
//   static final Navbar _navbar = Navbar._internal();
//
//   static int _selectedIndex = 0;
//
//   static BottomNavigationBar navbar = BottomNavigationBar(
//     backgroundColor: Colors.grey[900],
//     // type: BottomNavigationBarType.shifting,
//     items: const <BottomNavigationBarItem>[
//       BottomNavigationBarItem(
//         icon: Icon(Icons.search_rounded),
//         label: 'Search',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.sync_alt),
//         label: 'Convert',
//       ),
//     ],
//     selectedItemColor: AppUser.getColor(),
//     currentIndex: _selectedIndex,
//     onTap: _goToPage,
//     selectedFontSize: 12,
//     unselectedFontSize: 10,
//     selectedLabelStyle: style(),
//   );
//
//   Navbar._internal();
//
//   static void _goToPage(int index) {
//     if (index == _selectedIndex) {
//       return;
//     }
//     else if (index == 0) {
//       Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
//     }
//   }
//
// }