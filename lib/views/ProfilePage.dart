import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../services/database.dart';
import '../services/auth.dart';
import 'RegisterPage.dart';

class ProfilePage extends StatefulWidget {
    @override
    _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String,dynamic> _userInfo;
  TextEditingController _dateController = TextEditingController();
  late DateTime _birthdate;


  Future _pullUserInfo() async {
    _userInfo = await DatabaseMethods.getUserInfo();

    _birthdate = DateTime.parse(_userInfo["birthdate"].toDate().toString());
    _dateController.text = "${_birthdate.day}/${_birthdate.month}/${_birthdate.year}";
  }

  @override
  void initState() {
    
    super.initState();
    _pullUserInfo();

  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pullUserInfo(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none: return const Text("No preferences");
          case ConnectionState.waiting: return const Text("Loading...");
          default:
            return snapshot.hasError ? Text("Erro: ${snapshot.error}")
            : Container( 
              padding: const EdgeInsets.only(top: 30),
              child: Column( 
                children: [
                  Container( 
                    alignment: Alignment.topCenter,
                    child: const Text( "ProfilePage", style: TextStyle( fontSize: 15 ), ),
                  ),
                  Column(
                    children: [
                      Container(  
                        alignment: Alignment.topLeft,
                        child: Text("${_userInfo["nick"]} ${_userInfo["name"]}", style: TextStyle( fontSize: 15 ),),
                      ),
                      const SizedBox(height: 50,),
                      TextField(
                        focusNode: AwaysDisabledFocus(),
                        controller: _dateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Data Nasc.",
                        ),
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context, 
                            initialDate: _birthdate, 
                            firstDate: DateTime(1900), 
                            lastDate: DateTime.now(),
                          );

                          if(newDate == null) return;
                          _birthdate = newDate;
                          _dateController.text = '${newDate.day}/${newDate.month}/${newDate.year}';
                          _userInfo["birthdate"] = Timestamp.fromDate(newDate);
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 150),
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        ElevatedButton(
                          child: const Text('Salvar'),
                          onPressed: () {
                            
                            DatabaseMethods.updateUser(AuthService.auth.currentUser?.uid, _userInfo);
                            resetApp(context);
                            
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Sair'),
                          onPressed: () async {
                            
                            await AuthService.singOut();
                            resetApp(context);
                            
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: Text(
                            style: TextStyle(
                              color:  Colors.white
                            ),
                            'Excluir Conta'
                          ),
                          onPressed: () async {
                            
                            await DatabaseMethods.deleteUser();
                            resetApp(context);
                            
                          },
                        ),
                      ],
                    ),
                  ),
                  
                ]
              )
            );
        }
      }
    );
    
    
    
    
    
  }
}