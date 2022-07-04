import 'package:flutter/material.dart';

import '../main.dart';
import '../services/database.dart';
import '../services/auth.dart';
import 'EditingPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> feed = [];
  TextEditingController postController = TextEditingController();

  Widget _dataToWidget(String postId,dynamic post, dynamic user) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget> [
          Container(
            alignment:Alignment.topLeft, 
            child: Text(
              "${user["nick"]} ${user["name"]}:",
              textAlign: TextAlign.left, 
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 4), 
            child: Text(post["content"])
          ),
          !AuthService.isLoggedIn() 
          ? SizedBox(height: 10,)
          : post["id_creator"] == AuthService.auth.currentUser?.uid 
          ? Center( 
            child: Row(
              children: [
                ElevatedButton(
                  child: const Text('Editar'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditingPage(postId, post)
                      )
                    );
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
                    'Excluir'
                  ),
                  onPressed: () async {
                    
                    await DatabaseMethods.deletePost(postId);
                    resetApp(context);
                  },
                ),
              ],
            )
          )
          : Center(
            child: Row(
              children: [
                ElevatedButton(
                  child: const Text('Adicionar Contato'),
                  onPressed: () {

                    _addContact(post["id_creator"]);

                  },
                ),
              ],
            ),
          ),
          const Divider(thickness: 4,),  
        ],
      )
    );
  }

  Future<void> _addContact(String idContact) async {

    bool existContact = false;

    await DatabaseMethods.db.collection("users").doc(AuthService.auth.currentUser?.uid)
    .collection("chats").where("id_contact", isEqualTo: idContact).get().then(
      (value) => {
        for(var e in value.docs){
          if(e.data()["id_contact"] == idContact) {
            existContact = true
          },
          if(!existContact) {
            DatabaseMethods.addContact(idContact)
          } else {
            print("Contato ja registrado.")
          }
        }, 
      }
    );

  }

  Future _pullFeed() async {
    try{
      feed = [];
      var postsSnapshot = await DatabaseMethods.db.collection("posts").orderBy("post_time", descending: true).get();
      for(var postDocumentSnapshot in postsSnapshot.docs) {
        Map<String, dynamic> postData = postDocumentSnapshot.data();
        await DatabaseMethods.db.collection("users").doc(postData["id_creator"]).get().then(
          (value) => feed.add(_dataToWidget(postDocumentSnapshot.id, postData, value.data()))
        );
      } 
      
    } catch (err) {
      print("erroooooooou: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if(!AuthService.isLoggedIn()) {
      return FutureBuilder(
        future:_pullFeed(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: return const Text("No preferences");
            case ConnectionState.waiting: return const Text("Loading");
            default: 
              return snapshot.hasError ? Text("Erro: ${snapshot.error}") 
              : Container(
                padding: const EdgeInsets.only(top:5),
                child: ListView(children: feed)
              );
          }
        }
      );
    } else {
      return FutureBuilder(
        future:_pullFeed(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: return const Text("No preferences");
            case ConnectionState.waiting: return const Text("Loading");
            default: 
              return snapshot.hasError ? Text("Erro: ${snapshot.error}") 
              : Container(
                padding: const EdgeInsets.only(top:30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: postController,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Escreva...",
                            ),
                          )
                        ),
                        ElevatedButton(
                          child: const Text('Publicar'),
                          onPressed: () async {
                            
                            await DatabaseMethods.createPost(postController.text, 
                              AuthService.auth.currentUser?.uid as String);
                            postController.text = "";
                            resetApp(context);
                            
                          },
                        ),

                      ],
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: feed
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
}
