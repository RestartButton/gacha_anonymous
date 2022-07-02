import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AuthProvider.dart';

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
  late final AuthProvider _authProvider;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    dateController.text = '${date.day}/${date.month}/${date.year}';
    _authProvider = Provider.of<AuthProvider>(context);
  }

  void _register() async {
    if(passwordController.text == confirmController.text) {
      if(await _authProvider.createAccount(emailController.text, passwordController.text)) {

      }
    } else {
      print('As senhas precisam ser iguais.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text('Cadastrar'),

            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: confirmController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
                  labelText: 'Data Nasc.',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                child: const Text('Enviar'),
                onPressed: () {
                  _register();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
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