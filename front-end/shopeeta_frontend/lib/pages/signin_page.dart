import 'package:flutter/material.dart';
import 'package:shopeeta_frontend/pages/login_page.dart';

import '../models/user.dart';
import '../helpers/http_requests.dart';
import '../widgets/welcome_button.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});
  static const pageRouteName = "/signin";

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User user = User(email: "", password: "", userName: "");
  var _userNameIsValid = true;
  var _emailIsValid = true;
  var _accountCreated = false;
  var _errorOnCreate = false;

  void _saveForm() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      var response = await UserHttpRequestHelper.registerUser(user);

      if (response) {
        setState(() {
          _accountCreated = true;
          _errorOnCreate = false;
        });
      } else {
        _errorOnCreate = true;
      }
    }
  }

  void _verifyUserName(String userName) async {
    _userNameIsValid = await UserHttpRequestHelper.verifyUserName(userName);
  }

  void _verifyEmailAddress(String email) async {
    _emailIsValid = await UserHttpRequestHelper.verifyEmailAddress(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signin"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          const SizedBox(height: 30),
          Center(
            child: Container(
              width: 400,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 3,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                        '../assets/images/Logo_shopeeta_cart_on_top.png',
                        width: 220,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 10),
                    Text(
                      "Página de cadastro",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_errorOnCreate)
                            const Text(
                                "Ops... algo deu errado! Tente novamente por favor!"),
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
                            textInputAction: TextInputAction.next,
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
                              if (!_emailIsValid) {
                                return "Esse e-mail já está cadastrado!";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _verifyEmailAddress(value);
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (email) {
                              if (email != null) {
                                user.email = email;
                              }
                            },
                            textInputAction: TextInputAction.next,
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
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              setState(() {
                                user.password = value;
                              });
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Escreva a senha novamente",
                            ),
                            obscureText: true,
                            validator: (String? value) {
                              if (value != user.password) {
                                return "As senhas não coincidem";
                              }
                              if (value == null || value.length < 6) {
                                return "A senha deve ter pelo menos 6 caracteres";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              _saveForm();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (!_accountCreated)
                      const SizedBox(
                        height: 30,
                      ),
                    if (!_accountCreated)
                      WelcomeButton(
                        text: "Cadastrar!",
                        color: Theme.of(context).colorScheme.secondary,
                        textColor: Colors.black,
                        onPressed: () => _saveForm(),
                        iconChosen: Icons.person_add,
                      ),
                    if (_accountCreated)
                      SizedBox(
                        height: 30,
                        child: Text(
                          "Conta criada com sucesso!\n",
                          style: Theme.of(context).textTheme.bodyText1!,
                        ),
                      ),
                    if (_accountCreated)
                      WelcomeButton(
                        text: "Fazer login!",
                        color: Theme.of(context).colorScheme.secondary,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(LoginPage.pageRouteName);
                        },
                        iconChosen: Icons.person_add,
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
