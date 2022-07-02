import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gacha_anonymous/account/AuthProvider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();

    _authProvider = Provider.of<AuthProvider>(context);
  }


  @override
  Widget build(BuildContext context) {
    
    if(_authProvider.isLoggedIn()) {
      return const Text( "HomePage-Logged" );
    } else {
      return const Text( "HomePage" );
    }
  }
}
