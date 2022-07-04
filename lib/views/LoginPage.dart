import 'package:flutter/material.dart';

import '../main.dart';
import '../services/auth.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
    @override
    _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void callRegisterPage(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => RegisterPage()
      )
    );
  }

  void _login() async {
    if(await AuthService.singIn(nameController.text, passwordController.text)) {
      resetApp(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Login',
            )
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              '',
            )
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Usuário',
              ),
            )
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Senha',
              ),
            ),
          ),
          Container(
            child: const Text(''),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10,0,10,0),
            child: ElevatedButton(
              child: const Text('Entrar'),
              onPressed: () {
                _login();
              },
            ),
          ),
          Container(
            child: const Text(''),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10,0,10,0),
            child: ElevatedButton(
              child: const Text('Registrar'),
              onPressed: () {
                callRegisterPage(context);
              },
            )
          ),
        ],
      ),
    );
  }
}