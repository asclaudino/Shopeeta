import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const pageRouteName = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User user = User(email: "", password: "", userName: "");
  var _userNameIsValid = true;

  void _saveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      http
          .post(Uri.parse('http://localhost:8000/userbase/register/'),
              body:
                  '{"username": "${user.userName}", "password": "${user.password}", "email": "${user.email}"}')
          .then((response) {
        print(response.body);
      });
    }
  }

  void _verifyUserName(String userName) async {
    var response = await http.post(
        Uri.parse('http://localhost:8000/userbase/verify_username/'),
        body: '{"username": "$userName"}');
    if (json.decode(response.body)["status"] == "success") {
      _userNameIsValid = true;
    } else {
      _userNameIsValid = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Bem vindo à página de Login!"),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nome de usuário",
                    ),
                    validator: (String? userName) {
                      if (userName == null || userName.isEmpty) {
                        return "Nome de usuário não pode ser vazio";
                      }
                      if (!_userNameIsValid) {
                        return "Esse nome de usuário já existe";
                      }
                      return null;
                    },
                    onChanged: (userName) => {
                      setState(
                        () {
                          _verifyUserName(userName);
                        },
                      )
                    },
                    keyboardType: TextInputType.name,
                    onSaved: (userName) {
                      if (userName != null) {
                        user.userName = userName;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                    ),
                    validator: (String? value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "Digite um e-mail válido";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (email) {
                      if (email != null) {
                        user.email = email;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Escolha uma senha",
                    ),
                    obscureText: true,
                    validator: (String? value) {
                      if (value == null || value.length < 6) {
                        return "A senha deve ter pelo menos 6 caracteres";
                      }
                      return null;
                    },
                    onSaved: (password) {
                      if (password != null) {
                        user.password = password;
                      }
                    },
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
    );
  }
}
