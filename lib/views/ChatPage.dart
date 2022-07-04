import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../services/database.dart';
import '../services/auth.dart';

class ChatPage extends StatefulWidget {
  String contactName, idContact, idChat;

  ChatPage(this.contactName, this.idContact, this.idChat);

  @override
  _ChatPageState createState() => _ChatPageState(contactName, idContact, idChat);
}

class _ChatPageState extends State<ChatPage> {
  String? idUser, idContact, idChat, contactName;
  TextEditingController messageContentController = TextEditingController();
  late var _messageStream;

  _ChatPageState( this.contactName, this.idContact, this.idChat );

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: _messageStream,
      builder: ( context, snapshot ) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> message = snapshot.data?.docs[index].data() as Map<String,dynamic>;
            return MessageTile(
              message: message["content"], 
              sendByMe: idUser == message["id_sender"]
            );
          },
        ) : Container();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    idUser = AuthService.auth.currentUser?.uid;
    if(idUser == null || idContact == null) {
      resetApp(context);
    } else {
      _messageStream = _getMessages();
    }
  }

  _getMessages() {
    if(idChat != null) {
      if(idChat != "") {
        return DatabaseMethods.db.collection("chats").doc(idChat).collection("messages")
        .orderBy("sent_time",descending: false).snapshots();  
      } 
    }
  }

  _addMessage() {
    if(messageContentController.text.isNotEmpty) {
      DatabaseMethods.sendMessage(
        idChat, 
        {
          "content": messageContentController.text,
          "id_sender": idUser,
          "id_receiver": idContact,
        }
      );

      setState(() {
        messageContentController.text = "";
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0x28FFFFFF),
      appBar: AppBar(
        backgroundColor:const Color(0xff2A75BC),
        title: Text(
          contactName == null ? "Desconhecido" : contactName as String,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery
                .of(context)
                .size
                .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                color: Color(0x54CCCCCC),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageContentController,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 16
                        ),
                        decoration: const InputDecoration(
                          hintText: "Mensagem...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: ()  {
                        _addMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                               Color(0x36CCCCCC),
                               Color(0x0FCCCCCC)
                            ],
                            begin: FractionalOffset.topLeft,
                            end: FractionalOffset.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          "assets/images/send.png",
                          height: 25, width: 25,
                        ),//Text(" > ", style: TextStyle( fontSize: 20 )),
                      ),
                    )
                  ],
                )
              )
            ),
          ],
        )
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({
    required this.message, 
    required this.sendByMe
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0
      ),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(
            top: 17, 
            bottom: 17, 
            left: 20, 
            right: 20
        ),
        decoration: BoxDecoration(
            borderRadius: sendByMe 
              ? const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              ) 
              : const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23),
              ),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1ACCCCCC),
                const Color(0x1ACCCCCC)
              ],
            )
        ),
        child: Text(
          message,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          )
        ),
      ),
    );
  }
}