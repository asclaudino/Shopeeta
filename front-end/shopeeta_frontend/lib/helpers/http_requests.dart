import 'dart:convert';
import 'dart:core';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shopeeta_frontend/models/filter.dart';
import './base_urls.dart';
import '../models/product.dart';
import '../models/my_tuples.dart';
import '../models/user.dart';

class UserHttpRequestHelper {
  static const String baseBackEndUserUrl =
      "${BaseUrls.baseBackEndUrl}/userbase";

  static Future<bool> registerUser(User user) async {
    var response = await http.post(Uri.parse('$baseBackEndUserUrl/user/'),
        body:
            '{"username": "${user.userName}", "email": "${user.email}", "password": "${user.password}"}');
    return json.decode(response.body)["status"] == "success";
  }

  static Future<bool> verifyIfIsLogedIn(
      String userName, String password) async {
    var response = await http.put(Uri.parse('$baseBackEndUserUrl/user/'),
        body: '{"username": "$userName", "password": "$password"}');
    return json.decode(response.body)["status"] == "success";
  }

  static Future<bool> verifyEmailAddress(String email) async {
    var response = await http.post(
        Uri.parse('$baseBackEndUserUrl/verify_email/'),
        body: '{"email": "$email"}');
    return json.decode(response.body)["status"] == "success";
  }

  static Future<bool> verifyUserName(String userName) async {
    var response = await http.post(
        Uri.parse('$baseBackEndUserUrl/verify_username/'),
        body: '{"email": "$userName"}');
    return json.decode(response.body)["status"] == "success";
  }
}

//////////////////////////////////////////////////////////////////////

class ShopHttpRequestHelper {
  static const String baseBackEndShopUrl = "${BaseUrls.baseBackEndUrl}/shop";

  static Future<Pair<List<Product>, bool>> getLatestProducts() async {
    var response = await http.get(
      Uri.parse('$baseBackEndShopUrl/product/'),
    );
    if (json.decode(response.body)["status"] == "success") {
      var products =
          (json.decode(utf8.decode(response.bodyBytes))["products"] as List)
              .map((i) => Product.fromJson(i))
              .toList();
      return Pair(products, true);
    } else {
      return Pair(List<Product>.empty(), false);
    }
  }

  static Future<Trio<bool, bool, String>> addProduct(
    Product product,
    String userName,
    String password,
    PlatformFile? file,
    List<int> imageBytes,
  ) async {
    //---Create http package multipart request object
    final request = await http.post(
      Uri.parse('$baseBackEndShopUrl/product/'),
      body:
          """{"username": "$userName", "password": "$password", "name": "${product.name}", "description": "${product.description}", "price": "${product.price}"}""",
    );

    var response = json.decode(request.body);

    if (response["status"] != "success") {
      return Trio(false, false, response["message"]);
    }

    var productId = response["product_id"];

    if (file != null) {
      //---Add file to request
      return addImageToProduct(productId, file, imageBytes);
    }

    return Trio(true, true, "");
  }

  static Future<bool> deleteProduct(
      Product product, String userName, String password) async {
    var response = await http.delete(
      Uri.parse('$baseBackEndShopUrl/product/'),
      body:
          '{"product_id": "${product.id}", "username": "$userName", "password": "$password"}',
    );

    return json.decode(response.body)["status"] == "success";
  }

  static Future<Pair<List<Product>, bool>> searchProducts(
      String toBeSearched, List<Filter> filters) async {
    // ---TODO: implement searchProducts with filters
    var response = await http.post(
        Uri.parse('$baseBackEndShopUrl/search_products/'),
        body: '{"name": "$toBeSearched"}');
    if (json.decode(response.body)["status"] == "success") {
      var products =
          (json.decode(utf8.decode(response.bodyBytes))["products"] as List)
              .map((i) => Product.fromJson(i))
              .toList();
      return Pair(products, true);
    } else {
      return Pair(List<Product>.empty(), false);
    }
  }

  static Future<Pair<List<Product>, bool>> getMyProducts(
      String userName, String password) async {
    var response = await http.post(
      Uri.parse('$baseBackEndShopUrl/get_sellers_products/'),
      body: '{"seller": "$userName", "name": ""}',
    );
    if (json.decode(response.body)["status"] == "success") {
      var products =
          (json.decode(utf8.decode(response.bodyBytes))["products"] as List)
              .map((i) => Product.fromJson(i))
              .toList();
      return Pair(products, true);
    } else {
      return Pair(List<Product>.empty(), false);
    }
  }

  static Future<Pair<List<Product>, bool>> searchMyProducts(
      String userName, String toBeSearched) async {
    var response = await http.post(
      Uri.parse('$baseBackEndShopUrl/get_sellers_products/'),
      body: '{"seller": "$userName", "name": "$toBeSearched"}',
    );
    if (json.decode(response.body)["status"] == "success") {
      var products =
          (json.decode(utf8.decode(response.bodyBytes))["products"] as List)
              .map((i) => Product.fromJson(i))
              .toList();
      return Pair(products, true);
    } else {
      return Pair(List<Product>.empty(), false);
    }
  }

  static Future<Trio<bool, bool, String>> addImageToProduct(
    int productId,
    PlatformFile file,
    List<int> imageBytes,
  ) async {
    //---Create http package multipart request object
    final request = http.MultipartRequest(
      "POST",
      Uri.parse('$baseBackEndShopUrl/product_image/$productId/'),
    );

    //-----add selected file with request
    request.files.add(
      http.MultipartFile.fromBytes(
        "image",
        imageBytes,
        filename: file.name,
      ),
    );

    //-------Send request
    var resp = await request.send();

    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response is in result

    if (json.decode(result)["status"] == "success") {
      return Trio(true, true, "");
    } else {
      return Trio(false, false, json.decode(result)["message"]);
    }
  }

  static Future<Trio<String, bool, String>> getProductImage(
      int productId) async {
    var response = await http.get(
      Uri.parse('$baseBackEndShopUrl/product_image/$productId/'),
    );

    var body = json.decode(response.body);

    if (body["status"] == "success") {
      var imageUrl = body["image"] as String;
      if (imageUrl.isEmpty) {
        return Trio("", true, "No image found");
      }
      imageUrl = "${BaseUrls.baseBackEndUrl}/$imageUrl";
      return Trio(imageUrl, true, "");
    } else {
      return Trio("", false, body["message"]);
    }
  }
}
