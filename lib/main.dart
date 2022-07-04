import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gacha_anonymous/services/database.dart';

import 'services/auth.dart';
import 'views/ProfilePage.dart';
import 'views/LoginPage.dart';
import 'views/ContactsPage.dart';
import 'views/HomePage.dart';

final List<String> nicks = [
  "Cavalo",
  "Pato",
];
final List<String> names = [
  "Azul",
  "Grande",
];

Future main() async {
  try{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    AuthService.initAuth();
    DatabaseMethods.initDatabase();
    runApp(const MyApp());
  } catch (e) {
    print(e);
  }
}

void resetApp(dynamic context) {
  Navigator.pushReplacement(
    context, 
    PageRouteBuilder(
      pageBuilder: (_,__,___) => GachaAnon()
    )
  );
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
  Widget wg;

  TabItem( this.title, this.wg );
}

class GachaAnon extends StatefulWidget {
  @override
  _GachaAnonState createState() => _GachaAnonState();
}

class _GachaAnonState extends State<GachaAnon> {
  int _selectedIndex = 1;

  static late List<TabItem> bottomTabs;
  static late List<Widget> widgetOptions;

  @override
  void initState() {
    super.initState();

    if(AuthService.isLoggedIn()) {
      bottomTabs = [
        TabItem('Profile', ProfilePage()),
        TabItem('Chat', ContactsPage()),
        TabItem('Home', HomePage()),
      ];

      widgetOptions = <Widget>[
        ProfilePage(),
        ContactsPage(),
        HomePage(),
      ];

      _selectedIndex = 2;
    } else {
      bottomTabs = [
        TabItem('Login', LoginPage()),
        TabItem('Home', HomePage()),
      ];

      widgetOptions = <Widget>[
        LoginPage(),
        HomePage(),
      ];
    }
  }

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

