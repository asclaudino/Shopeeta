import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/http_requests.dart';
import '../models/product.dart';
import '../widgets/image_upload_field.dart';
import './my_profile_page.dart';
import './wait_for_connection_page.dart';
import '../widgets/home_top_bar.dart';

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
  PlatformFile? _image;
  Uint8List? _imageBytes;
  List<int> _bytesList = [];

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
          sellerEmail: "",
          id: -1, // id will be set by the server
        ),
        userName,
        password,
        _image,
        _bytesList,
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

  void _chooseFileUsingFilePicker() async {
    //-----pick file by file picker,

    var result = await FilePicker.platform.pickFiles(
      withReadStream:
          true, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      _image = result.files.last;
      _image!.readStream!.last.then((value) {
        _bytesList = value;
        _imageBytes = Uint8List.fromList(_bytesList);
        setState(() {});
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
          HomeTopBar(
            sideBarWidth: _sideBarWidth,
            searchBarHeight: _searchBarHeight,
            context: context,
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - _searchBarHeight - 30,
            child: SingleChildScrollView(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(30),
                    width: 800.0,
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
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
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
                                var priceString = value.replaceAll(',', '.');
                                if (double.tryParse(priceString) == null) {
                                  return 'Por favor, digite um valor válido';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                var priceString =
                                    newValue!.replaceAll(',', '.');
                                price = double.parse(priceString);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              minLines: 4,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Descrição do produto',
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
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: FileUploadWithHttp(
                                chooseFileUsingFilePicker:
                                    _chooseFileUsingFilePicker,
                                objFile: _image,
                                imageBytes: _imageBytes,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (!_productAdded)
                              const SizedBox(
                                height: 30,
                              ),
                            if (!_productAdded)
                              ElevatedButton.icon(
                                onPressed: () {
                                  _registerProduct();
                                },
                                icon: const Icon(
                                  Icons.queue,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                label: const Text.rich(
                                  TextSpan(
                                    text: "Cadastrar produto",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            if (_productAdded)
                              const SizedBox(
                                height: 30,
                                child: Text.rich(
                                  TextSpan(
                                    text: "Produto adicionado com sucesso!\n",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            if (_productAdded)
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, MyProfilePage.pageRouteName),
                                icon: const Icon(
                                  Icons.reply_sharp,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                label: const SizedBox(
                                  width: 120.0,
                                  child: Text.rich(
                                    TextSpan(
                                      text: "Retornar ao perfil",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.primary,
                                ),
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
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
