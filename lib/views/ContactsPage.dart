import 'package:flutter/material.dart';

import '../main.dart';
import '../services/database.dart';
import '../services/auth.dart';
import 'ChatPage.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late final String? idUser;
  List<Widget> _contacts = [];

  @override
  void initState() {
    super.initState();
    idUser = AuthService.auth.currentUser?.uid ;
    if(idUser == null) {
      AuthService.singOut();
      resetApp(context);
    }
  }

  Widget _dataToWidget(String idContact, dynamic contact, String idChat) {
    return  Column(
      children: [
        Container( 
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF080595), 
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: TextButton(
            onPressed: ()  {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage("${contact["nick"]} ${contact["name"]}", idContact, idChat)
                )
              );
            },
            child: ListTile(
              title: Text(
                "${contact["nick"]} ${contact["name"]}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          )
        ), 
        SizedBox(height: 4,)
      ]
    );
  }

  Future _pullContacts() async {
    try{
      _contacts = [];
      var contactsSnapshot = await DatabaseMethods.db.collection("contacts").where("id_user", isEqualTo: idUser).get();
      for(var contactDocumentSnapshot in contactsSnapshot.docs) {
        Map<String, dynamic> contactData = contactDocumentSnapshot.data();
        var chatSnapshot = await DatabaseMethods.db.collection("users").doc(idUser).collection("chats")
          .where("id_contact", isEqualTo: contactData["id_contact"]).get();
        for(var  chatDocumentSnapshot in chatSnapshot.docs)  {
          Map<String,dynamic> chatData = chatDocumentSnapshot.data();
          await DatabaseMethods.db.collection("users").doc(contactData['id_contact']).get().then(
            (value) => _contacts.add(_dataToWidget(contactData['id_contact'], value.data(), chatData["id"]))
          );
        }
        
      }
    } catch (err) {
      print("erroooooooooooooo: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future:_pullContacts(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none: return const Text("No preferences");
          case ConnectionState.waiting: return const Text("Loading");
          default: 
            return snapshot.hasError ? Text("Erro: ${snapshot.error}") 
            : Column(
              children: [
                Padding(
                  padding: EdgeInsets.only( top: 10 ),
                  child: Container(
                    padding: const EdgeInsets.only( top: 25 ), 
                    child: Center(
                      child: Text(
                        "Contacts",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ),
                  )
                ),
                ListView(
                  shrinkWrap: true, 
                  children: _contacts
                ),
              ],
            );
        }
      }
    );
  }
}