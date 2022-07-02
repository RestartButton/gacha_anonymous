import 'package:flutter/material.dart';
import 'package:gacha_anonymous/main.dart';

import 'AuthProvider.dart';

class ProfilePage extends StatefulWidget {
    @override
    _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: const EdgeInsets.only(top: 200),
      child: ListView( 
        children: [
          const Center( 
            child:Text( "ProfilePage" )
          ),
          ElevatedButton(
            child: const Text('Sair'),
            onPressed: () {
              
              AuthProvider.singOut();
              Navigator.pushReplacement(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_,__,___) => GachaAnon()
                )
              );
              
            },
          ),
        ]
      )
    );
  }
}