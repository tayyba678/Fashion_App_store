import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item_model.dart';

//TODO:: Manage products added to the cart during the current app run.
final cartProvider =
StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

//TODO:: Manage the current cart items.
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  //TODO:: Add a product to the cart.
  void addToCart(CartItem item) {
    state = [
      ...state,
      item,
    ];
  }

  //TODO:: Remove a product from the cart.
  void removeFromCart(int index) {
    final updatedCart = [...state];

    if (index >= 0 && index < updatedCart.length) {
      updatedCart.removeAt(index);
    }

    state = updatedCart;
  }

  //TODO:: Update the quantity of a cart item.
  void updateQuantity(int index, int quantity) {
    final updatedCart = [...state];

    if (index >= 0 && index < updatedCart.length) {
      updatedCart[index] = updatedCart[index].copyWith(
        quantity: quantity,
      );
    }

    state = updatedCart;
  }
}