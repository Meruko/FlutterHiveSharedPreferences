import 'package:flutter/material.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.pass});

  final String pass;
  
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  late TextEditingController _controller;
  String? pass = preferences.get('pass')?.toString();

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    pass ??= 'pass';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter password',
              ),
            ),
            ElevatedButton(
              onPressed: (){
                if (_controller.text == pass){
                  Navigator.restorablePushNamedAndRemoveUntil(context, 'home', (route) => false);
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Неверный пароль!'))
                  );
                }
              }, 
              child: const Text('Вход')
            ),
          ],
        ),
      )
    );
  }
}
