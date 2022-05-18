import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/my_tuples.dart';
import 'package:flutter/material.dart';

import './base_urls.dart';

class HttpRequestHelper {
  static const String baseBackEndUrl = BaseUrls.baseBackEndUrl;

  Future<bool> verifyIfIsLogedIn(String userName, String password) async {
    var response = await http.post(Uri.parse('$baseBackEndUrl/userbase/login/'),
        body: '{"username": "$userName", "password": "$password"}');
    if (json.decode(response.body)["status"] == "success") {
      return true;
    }
    return false;
  }

  Future<Pair<List<Product>, bool>> getLatestProducts() async {
    var response = await http.get(
      Uri.parse('$baseBackEndUrl/shop/get_latest_products/'),
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

  Future<Pair<List<Product>, bool>> searchProducts(
      GlobalKey<FormState> form, String toBeSearched) async {
    var response = await http.post(
        Uri.parse('$baseBackEndUrl/shop/search_products/'),
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
}
