import 'package:flutter/material.dart';

import './login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bem vindo!',
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    LoginPage.pageRouteName,
                  );
                },
                child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
