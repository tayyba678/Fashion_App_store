import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../utils/app_constants.dart';

//*TODO:: This service is responsible for communicating with the product API.*
class ApiService {
  //*TODO:: Fashion categories available from DummyJSON.*
  static const List<String> _fashionCategories = [
    'womens-dresses',
    'mens-shirts',
    'mens-shoes',
    'womens-shoes',
    'womens-bags',
    'mens-watches',
    'womens-watches',
    'womens-jewellery',
    'sunglasses',
  ];

  //*TODO:: Fetch all fashion products from the product API.*
  Future<List<ProductModel>> fetchProducts() async {
    final List<ProductModel> products = [];

    //*TODO:: Fetch products from every selected fashion category.*
    for (final category in _fashionCategories) {
      final response = await http
          .get(
        Uri.parse(
          '${AppConstants.productsUrl}/category/$category?limit=0',
        ),
      )
          .timeout(AppConstants.apiTimeout);

      //*TODO:: Process the response only when the API request succeeds.*
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        //*TODO:: Convert every JSON product into a ProductModel.*
        final List<dynamic> categoryProducts = data['products'] ?? [];

        products.addAll(
          categoryProducts.map(
                (item) => ProductModel.fromJson(
              item as Map<String, dynamic>,
            ),
          ),
        );
      } else {
        //*TODO:: Inform the caller when a category request fails.*
        throw Exception(
          'Failed to load $category products: ${response.statusCode}',
        );
      }
    }

    //*TODO:: Remove duplicate products before returning the complete fashion catalog.*
    final uniqueProducts = <int, ProductModel>{};

    for (final product in products) {
      uniqueProducts[product.id] = product;
    }

    return uniqueProducts.values.toList();
  }
}