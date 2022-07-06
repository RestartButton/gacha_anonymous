import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'services/database.dart';
import 'services/auth.dart';
import 'views/ContactsPage.dart';
import 'views/HomePage.dart';
import 'views/LoginPage.dart';
import 'views/ProfilePage.dart';

final List<String> nicks = [
  "Cavalo", "Jaguar", "Lontra", "Galinha",
  "Pato", "Puma", "Ganso", "Formiga",
  "Tigre", "Cachorro", "Gato", "Iguana",
  "Barata", "Girafa", "Peixe", "Golfinho",
  "Salamandra", "Jumento", "Burro", "Lagarto",
  "Bola", "Caneta", "Mesa", "Caderno",
  "Teclado", "Camiseta", "Fogo", "Porta",
  "Tambor", "Quadro", "Telefone", "Folha",
  "Roda", "Mochila", "Roupa", "Garrafa",
  "Janela", "Adesivo", "Gaveta", "Jarra",
];
final List<String> names = [
  "Azul", "Preto(a)", "Verde", "Cinza", "Transparente"
  "Grande", "Pequeno(a)", "Torto(a)", "Quadrado(a)", "Redondo(a)"
  "Legal", "Chato(a)", "Frio(a)", "Bravo(a)", "Tranquilo(a)",
  "de Madeira", "de Pano", "de Metal", "de Brincar", "de Tinta",
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

  Widget _getButton(TabItem item) {
    return item.title == 'Chat' 
      ? Container(
        height: 75,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(vertical: 4),
        child: ElevatedButton(
          child: Text(
            item.title
          ),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF56705F),
            fixedSize: const Size(100,75),
            shape: const CircleBorder(),
          ),
          onPressed: () {
            _onItemTapped(bottomTabs.indexOf(item));
          }, 
        )
      )
      : Container(
          height: 60,
          padding: AuthService.isLoggedIn() 
          ? EdgeInsets.symmetric(horizontal: 10) 
          : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: item.title == 'Home' ? Alignment.bottomRight : Alignment.bottomLeft,
          child: ElevatedButton(
            child: Text(
              item.title,
            ),
            style: ElevatedButton.styleFrom(
              padding: AuthService.isLoggedIn() 
              ? EdgeInsets.symmetric(horizontal: 30) 
              : EdgeInsets.symmetric(horizontal: 50),
              primary: item.title == 'Home' ? Color(0xFFCC1CCF) : Color(0xFF080595),
            ),
            onPressed: () {
              _onItemTapped(bottomTabs.indexOf(item));
            },
        )
      );

  }

  List<Widget> _getBottomTabs(List<TabItem> tabs) {
    return tabs
      .map((item) => _getButton(item))
      .toList();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ), 
      

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),

          gradient: const LinearGradient(
            colors: [
                Colors.white70,
                Colors.white54,
                Colors.white30,
            ],
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Stack( 
          children: _getBottomTabs(bottomTabs)
        ),
      ),
      backgroundColor: Color(0xFFC4C4C4),
    );
  }
}

