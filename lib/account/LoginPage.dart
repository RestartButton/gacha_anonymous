import 'package:flutter/material.dart';
import 'package:gacha_anonymous/main.dart';
import 'AuthProvider.dart';
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
    if(await AuthProvider.singIn(nameController.text, passwordController.text)) {
      Navigator.pushReplacement(
          context, 
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (_,__,___) => GachaAnon(),
          )
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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