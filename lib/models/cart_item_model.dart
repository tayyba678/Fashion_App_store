import 'product_model.dart';

//TODO:: Store the product information added to the cart.
class CartItem {
  final ProductModel product;
  final int quantity;
  final String selectedSize;
  final int selectedImageIndex;

  CartItem({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.selectedImageIndex,
  });

  //TODO:: Create a copy of the cart item with updated values.
  CartItem copyWith({
    ProductModel? product,
    int? quantity,
    String? selectedSize,
    int? selectedImageIndex,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedImageIndex:
      selectedImageIndex ?? this.selectedImageIndex,
    );
  }
}