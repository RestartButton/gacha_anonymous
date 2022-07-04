import 'package:flutter/material.dart';
import 'package:gacha_anonymous/main.dart';
import 'package:gacha_anonymous/services/auth.dart';
import 'package:gacha_anonymous/services/database.dart';
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
          post["id_creator"] == AuthService.auth.currentUser?.uid 
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
          : const SizedBox(height: 2,),
          const Divider(thickness: 4,),  
        ],
      )
    );
  }

  Future _pushFeed() async {
    try{
      var postsSnapshot = await DatabaseMethods.db.collection("posts").get();
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
        future:_pushFeed(),
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
        future:_pushFeed(),
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
