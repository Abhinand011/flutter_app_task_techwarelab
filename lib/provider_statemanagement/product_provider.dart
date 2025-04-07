import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<dynamic> _products = [];
  List<dynamic> _originalProducts = [];
  bool _isLoading = true;

  List<dynamic> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://dummyjson.com/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _products = jsonData['products'];
      _originalProducts = _products;
      _isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }
  }

  void searchProducts(String query) {
    _products = _originalProducts
        .where((element) => element['title']
        .toString()
        .toLowerCase()
        .contains(query.trim().toLowerCase()))
        .toList();
    notifyListeners();
  }
}
