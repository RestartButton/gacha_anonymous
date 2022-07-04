
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
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              scrollPadding: EdgeInsets.all(20.0),
              keyboardType: TextInputType.multiline,
              maxLines: 99999,
              autofocus: true,
              controller: postContentController,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ]
        )
      ), 
      bottomNavigationBar: Container(
        height: 83,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.only(right: 8, bottom: 8),
        child: ElevatedButton(
          
          child: const Text(
            'Salvar'
          ),
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(75, 75),
            shape: const CircleBorder(),
          ),
          onPressed: () {
            
            DatabaseMethods.updatePost(postId, postContentController.text);
            Navigator.pop(context);
            
          },
        )
      ),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: true,
    );
  }
}
