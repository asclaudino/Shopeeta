import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/my_tuples.dart';
import '../models/user.dart';

import './base_urls.dart';

class UserHttpRequestHelper {
  static const String baseBackEndUserUrl =
      "${BaseUrls.baseBackEndUrl}/userbase";

  static Future<bool> verifyIfIsLogedIn(
      String userName, String password) async {
    var response = await http.post(Uri.parse('$baseBackEndUserUrl/login/'),
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

  static Future<bool> registerUser(User user) async {
    var response = await http.post(Uri.parse('$baseBackEndUserUrl/register/'),
        body:
            '{"username": "${user.userName}", "email": "${user.email}", "password": "${user.password}"}');
    return json.decode(response.body)["status"] == "success";
  }
}

class ShopHttpRequestHelper {
  static const String baseBackEndShopUrl = "${BaseUrls.baseBackEndUrl}/shop";

  static Future<Pair<List<Product>, bool>> getLatestProducts() async {
    var response = await http.get(
      Uri.parse('$baseBackEndShopUrl/get_latest_products/'),
    );
    if (json.decode(response.body)["status"] == "success") {
      var products = (json.decode(response.body)["products"] as List)
          .map((i) => Product.fromJson(i))
          .toList();
      return Pair(products, true);
    } else {
      return Pair(List<Product>.empty(), false);
    }
  }

  static Future<Pair<List<Product>, bool>> searchProducts(
      String toBeSearched) async {
    var response = await http.post(
        Uri.parse('$baseBackEndShopUrl/search_products/'),
        body: '{"name": "$toBeSearched"}');
    if (json.decode(response.body)["status"] == "success") {
      var products = (json.decode(response.body)["products"] as List)
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
      Uri.parse('http://localhost:8000/shop/get_sellers_products/'),
      body: '{"seller": "$userName"}',
    );
    if (json.decode(response.body)["status"] == "success") {
      var products = (json.decode(response.body)["products"] as List)
          .map((i) => Product.fromJson(i))
          .toList();
      return Pair(products, true);
    } else {
      return Pair(List<Product>.empty(), false);
    }
  }

  static Future<bool> deleteProduct(
      Product product, String userName, String password) async {
    var response = await http.post(
        Uri.parse('$baseBackEndShopUrl/delete_product/'),
        body:
            '{"product_id": "${product.id}", "username": "$userName", "password": "$password"}');

    return json.decode(response.body)["status"] == "success";
  }

  static Future<Trio<bool, bool, String>> addProduct(
      Product product, String userName, String password) async {
    var response = await http.post(
        Uri.parse('$baseBackEndShopUrl/register_product/'),
        body:
            '{"username": "$userName", "password": "$password", "name": "${product.name}", "description": "${product.description}", "price": ${product.price}}');
    if (json.decode(response.body)["status"] == "success") {
      return Trio(true, true, "");
    } else {
      return Trio(false, false, json.decode(response.body)["message"]);
    }
  }
}
