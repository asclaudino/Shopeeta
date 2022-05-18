import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeeta_frontend/helpers/http_requests.dart';
import 'package:shopeeta_frontend/models/product.dart';
import 'package:shopeeta_frontend/pages/my_profile_page.dart';

import './wait_for_connection_page.dart';
import './home_page.dart';

class RegisterProductPage extends StatefulWidget {
  const RegisterProductPage({super.key});
  static const pageRouteName = '/register_product';

  @override
  State<RegisterProductPage> createState() => _RegisterProductPageState();
}

class _RegisterProductPageState extends State<RegisterProductPage> {
  bool _logedIn = false;
  String userName = "";
  String password = "";
  final _searchBarHeight = 50.0;
  final _sideBarWidth = 200.0;
  double price = 0;
  String name = "";
  String description = "";
  final _formKey = GlobalKey<FormState>();
  var _productAdded = false;
  var _errorOnAdd = false;
  var _errorOnAddMessage = "";

  void _registerProduct() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      var response = await ShopHttpRequestHelper.addProduct(
        Product(
          name: name,
          description: description,
          price: price,
          seller: name,
          id: -1, // id will be set by the server
        ),
        userName,
        password,
      );
      if (response.success) {
        setState(() {
          _productAdded = true;
          _errorOnAdd = false;
        });
      } else {
        setState(() {
          _errorOnAdd = true;
          _productAdded = false;
          _errorOnAddMessage = response.errorMessage;
        });
      }
    }
  }

  void _verifyIfIsLogedIn() async {
    var response =
        await UserHttpRequestHelper.verifyIfIsLogedIn(userName, password);
    if (response) {
      setState(() {
        _logedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var prefs = SharedPreferences.getInstance();
    prefs.then((prefs) {
      userName = prefs.getString('userName')!;
      password = prefs.getString('password')!;
      if (!_logedIn) _verifyIfIsLogedIn();
    });
    if (!_logedIn) return const WaitForConnectionPage();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: _searchBarHeight,
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: _sideBarWidth,
                  child: TextButton(
                    child: Text(
                      'Shopeeta',
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 26,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, HomePage.pageRouteName);
                    },
                  ),
                ),
                Expanded(child: Container()),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                  width: _sideBarWidth,
                  height: MediaQuery.of(context).size.height - _searchBarHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Filtros'),
                      Text('Você está logado!'),
                    ],
                  ),
                ),
                const VerticalDivider(
                  indent: 10,
                  endIndent: 10,
                  width: 10,
                  thickness: 0,
                  color: Colors.black54,
                ),
                Container(
                  padding: const EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width - _sideBarWidth - 10,
                  height: MediaQuery.of(context).size.height - _searchBarHeight,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Nome do produto',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite o nome do produto';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            name = value!;
                          },
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Preço',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite o preço do produto';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Por favor, digite um valor válido';
                            }
                            if (value.contains(',')) {
                              return 'Por favor, use ponto, não vírgula';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            price = double.parse(newValue!);
                          },
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite a descrição do produto';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            description = newValue!;
                          },
                          onFieldSubmitted: (value) {
                            _formKey.currentState!.validate();
                          },
                        ),
                        if (!_productAdded)
                          TextButton(
                            onPressed: () {
                              _registerProduct();
                            },
                            child: const Text('cadastrar'),
                          ),
                        if (_productAdded)
                          const Text("Produto adicionado com sucesso!"),
                        if (_productAdded)
                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, MyProfilePage.pageRouteName),
                            child: const Text("Voltar"),
                          ),
                        if (_errorOnAdd)
                          Text(
                            _errorOnAddMessage,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
