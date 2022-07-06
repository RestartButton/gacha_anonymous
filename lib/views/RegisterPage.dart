import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../services/database.dart';
import '../services/auth.dart';
import '../main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class AwaysDisabledFocus extends FocusNode {
  @override 
  bool get hasFocus => false;
}

class _RegisterPageState extends State<RegisterPage> {
  DateTime date = DateTime.now();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    dateController.text = '${date.day}/${date.month}/${date.year}';
  }

  void _register() async {
    if(passwordController.text == confirmController.text) {
      if(await AuthService.createAccount(emailController.text, passwordController.text)) {
        DatabaseMethods.updateUser(AuthService.auth.currentUser?.uid,{
          "birthdate": Timestamp.fromDate(date),
          "nick": nicks[Random().nextInt(nicks.length)],
          "name": names[Random().nextInt(names.length)],
        });
        resetApp(context);
      }
    } else {
      print('As senhas precisam ser iguais.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC4C4C4),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cadastrar",
          style: TextStyle(
            color: Colors.white
          )
        ),
        backgroundColor: Color(0xFF080595),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(''),

            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  //border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  //border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                controller: confirmController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  //border: OutlineInputBorder(),
                  labelText: 'Repetir Senha',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                focusNode: AwaysDisabledFocus(),
                controller: dateController,
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context, 
                    initialDate: date, 
                    firstDate: DateTime(1900), 
                    lastDate: DateTime.now(),
                  );

                  if(newDate == null) return;

                  setState(() => {
                    date = newDate,
                    dateController.text = '${date.day}/${date.month}/${date.year}',
                  });
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  //border: OutlineInputBorder(),
                  labelText: 'Data Nasc.',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCC1CCF)
                ),
                child: const Text('Enviar'),
                onPressed: () {
                  _register();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF080595)
                ),
                child: const Text('Voltar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}