import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';

//TODO:: Provide the API service to the application.
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

//TODO:: Fetch and manage product data from the API.
final productProvider = FutureProvider<List<ProductModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);

  return apiService.fetchProducts();
});

//TODO:: Manage the currently selected product category.
final selectedCategoryProvider = StateProvider<String>((ref) {
  return 'All';
});

//TODO:: Manage the current product search query.
final searchQueryProvider = StateProvider<String>((ref) {
  return '';
});

//TODO:: Manage the selected thumbnail separately for each product.
final selectedImageIndexProvider =
    StateProvider.family<int, int>((ref, productId) {
  return 0;
});

//TODO:: Manage the quantity separately for each product.
final quantityProvider = StateProvider.family<int, int>((ref, productId) {
  return 1;
});

//TODO:: Manage the selected color separately for each product.
final selectedColorProvider = StateProvider.family<int, int>((ref, productId) {
  return 0;
});

//TODO:: Manage the selected size separately for each product.
final selectedSizeProvider = StateProvider.family<int, int>((ref, productId) {
  return 0;
});
