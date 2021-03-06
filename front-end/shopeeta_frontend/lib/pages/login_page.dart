import 'package:flutter/material.dart';
import 'package:shopeeta_frontend/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../helpers/http_requests.dart';
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
      UserHttpRequestHelper.verifyIfIsLogedIn(_user.userName, _user.password)
          .then((response) {
        if (response) {
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
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                spreadRadius: 3,
                color: Colors.black.withOpacity(0.1),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                          '../assets/images/Logo_shopeeta_cart_on_top.png',
                          width: 220,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 10),
                      Text(
                        "Login",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      if (!_successOnLogin)
                        SizedBox(
                          height: 50,
                          child: Text(
                            "\nUsu??rio ou senha incorretos.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                          ),
                        ),
                      if (_successOnLogin)
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
                                labelText: "Nome de usu??rio",
                              ),
                              validator: (String? userName) {
                                if (userName == null || userName.isEmpty) {
                                  return "Preencha seu nome de usu??rio!";
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
                              onFieldSubmitted: (value) {
                                _saveForm();
                              },
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
                        color: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onPrimary,
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
