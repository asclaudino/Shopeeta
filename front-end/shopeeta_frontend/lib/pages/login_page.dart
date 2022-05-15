import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopeeta_frontend/pages/home_page.dart';
import 'dart:convert';

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
          Navigator.of(context)
              .pushReplacementNamed(HomePage.pageRouteName, arguments: {
            "userName": _user.userName,
            "password": _user.password,
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
      body: Row(
        children: [
          Container(
            color: Theme.of(context).colorScheme.background,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: [
                const Text("Bem vindo à página de Login!"),
                if (!_successOnLogin)
                  const Text("O nome de usuário e senha devem estar corretos."),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      TextButton(
                        onPressed: () {
                          _saveForm();
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white54,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(children: [
              const Text("Novo por aqui?"),
              WelcomeButton(
                text: "Cadastrar-se",
                onPressed: () {
                  Navigator.of(context).pushNamed(SigninPage.pageRouteName);
                },
              )
            ]),
          ),
        ],
      ),
    );
  }
}
