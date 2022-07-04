
import 'package:flutter/material.dart';
import '../services/database.dart';

class EditingPage extends StatefulWidget {
  Map<String,dynamic> post;
  String postId;

  EditingPage(this.postId,this.post);

  @override
  _EditingPageState createState() => _EditingPageState(postId, post);
}

class _EditingPageState extends State<EditingPage> {
  Map<String,dynamic> post;
  String postId;
  TextEditingController postContentController = TextEditingController();

  _EditingPageState(this.postId, this.post);

  @override
  void initState() {
    super.initState();

    postContentController.text = post["content"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container( 
        padding: const EdgeInsets.only(top: 25),
        child: Stack(
          children: [
            TextField(
              controller: postContentController,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Expanded(
                child: ElevatedButton(
                  child: const Text(
                    'Salvar'
                  ),
                  onPressed: () {
                    
                    DatabaseMethods.updatePost(postId, postContentController.text);
                    Navigator.pop(context);
                    
                  },
                )
              )
            )
          ],
        )
      )
    );
  }
}
