import 'package:flutter/material.dart';
import 'package:gacha_anonymous/account/AuthProvider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    
    if(AuthProvider.isLoggedIn()) {
      return const Text( "HomePage-Logged" );
    } else {
      return const Text( "HomePage" );
    }
  }
}
