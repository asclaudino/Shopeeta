import 'package:flutter/material.dart';

import './login_page.dart';
import '../widgets/welcome_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                            '../assets/images/Logo_shopeeta_cart_on_top.png',
                            width: 400,
                            color: Colors.white),
                        const SizedBox(height: 10),
                        Text(
                          'o comércio virtual do H8',
                          style: TextStyle(
                            fontSize: 37,
                            fontStyle: FontStyle.italic,
                            //fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 300,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            right: 8.0,
                            left: 8.0,
                          ),
                          child: WelcomeButton(
                            color: Theme.of(context).colorScheme.secondary,
                            textColor:
                                Theme.of(context).colorScheme.onSecondary,
                            text: 'Entrar',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(LoginPage.pageRouteName),
                            iconChosen: Icons.login,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
