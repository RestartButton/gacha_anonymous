
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
      backgroundColor: Color(0xFFC4C4C4),
      appBar: AppBar(
        backgroundColor: Color(0xFF080595),
        title: Text(""),
      ),
      body: EditingInput(postContentController),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Salvar',
        child: const Text(
          'Salvar'
        ),
        backgroundColor: Color(0xFF080595),
        onPressed: () {
          
          DatabaseMethods.updatePost(postId, postContentController.text);
          Navigator.pop(context);
          
        },
      ),
    );
  }
}



class EditingInput extends StatelessWidget {
  TextEditingController controller;
  EditingInput(this.controller);

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              scrollPadding: EdgeInsets.all(20.0),
              keyboardType: TextInputType.multiline,
              maxLines: 99999,
              autofocus: true,
              controller: controller,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ]
        )
      );

  }
}
