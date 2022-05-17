import 'package:flutter/material.dart';
import './login_page.dart';

class WaitForConnectionPage extends StatelessWidget {
  const WaitForConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olá, visitante!'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(LoginPage.pageRouteName);
          },
          child: const Text("Fazer login!"),
        ),
      ),
    );
  }
}
