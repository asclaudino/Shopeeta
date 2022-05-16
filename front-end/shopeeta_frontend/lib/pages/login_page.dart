import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopeeta_frontend/pages/home_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import './signin_page.dart';
import '../widgets/welcome_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const pageRouteName = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = User(email: "", password: "", userName: "");
  var _successOnLogin = true;

  void _saveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      http
          .post(Uri.parse('http://localhost:8000/userbase/login/'),
              body:
                  '{"username": "${_user.userName}", "password": "${_user.password}"}')
          .then((response) {
        if (json.decode(response.body)["status"] == "success") {
          var prefs = SharedPreferences.getInstance();
          prefs.then((prefs) {
            prefs.setString('userName', _user.userName);
            prefs.setString('password', _user.password);
            Navigator.of(context).pushReplacementNamed(HomePage.pageRouteName);
          });
        } else {
          setState(() {
            _successOnLogin = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Container(
          height: 500,
          width: 700,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                spreadRadius: 3,
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Shopeeta",
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Text(
                        "Login",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      if (!_successOnLogin)
                        Text(
                          "O nome de usuário e senha devem estar corretos.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onError,
                              ),
                        ),
                      const SizedBox(
                        height: 50,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Nome de usuário",
                              ),
                              validator: (String? userName) {
                                if (userName == null || userName.isEmpty) {
                                  return "Preencha seu nome de usuário!";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              onSaved: (userName) {
                                if (userName != null) {
                                  _user.userName = userName;
                                }
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Senha",
                              ),
                              obscureText: true,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Preencha a senha!";
                                }
                                return null;
                              },
                              onSaved: (password) {
                                if (password != null) {
                                  _user.password = password;
                                }
                              },
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextButton(
                              onPressed: () {
                                _saveForm();
                              },
                              child: Text(
                                "Entrar",
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(
                indent: 10,
                endIndent: 10,
                width: 10,
                thickness: 0,
                color: Colors.black54,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Novo por aqui?",
                        style: Theme.of(context).textTheme.headline2!,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      WelcomeButton(
                        text: "Cadastrar-se",
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(SigninPage.pageRouteName);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
