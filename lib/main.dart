import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'account/LoginPage.dart';
import 'home/HomePage.dart';

Future main() async {
  try{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const MyApp());
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GachaAnon(),
    );
  }
}

class TabItem {
  String title;

  TabItem(this.title);
}

class GachaAnon extends StatefulWidget {
  @override
  _GachaAnonState createState() => _GachaAnonState();
}

class _GachaAnonState extends State<GachaAnon> {
  int _selectedIndex = 1;

  static List<TabItem> bottomTabs = [
    TabItem('Login'),
    TabItem('Home'),
  ];

  static List<Widget> widgetOptions = <Widget>[
    LoginPage(),
    HomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> getBottomTabs(List<TabItem> tabs) {
    return tabs
      .map((item) =>
        BottomNavigationBarItem(
          icon: Container(height: 0.0,),
          label: item.title,
        ),
      )
      .toList();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ), 
      

      bottomNavigationBar: BottomNavigationBar(
        items: getBottomTabs(bottomTabs),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

