//*TODO:: Fixed values used across the app (API link, prices, categories).
class AppConstants {
  AppConstants._();

  //*TODO:: Image Asset*
  static const String welcomeImage = 'assets/images/welcome.png';
  static const String googleImage = 'assets/images/google.png';
  static const String arrowImage = 'assets/images/arrow.png';

  //*TODO:: Header
  static const String cartIcon = 'assets/images/cart.png';
  static const String menuIcon = 'assets/images/header_vertical.png';
  static const String searchIcon = 'assets/images/search.png';
  static const String dividerIcon = 'assets/images/vertical_line.png';
  static const String filterIcon = 'assets/images/search_vertical.png';

  //*TODO:: Product card
  static const String heartIcon = 'assets/images/heart.png';

  //*TODO:: Bottom navigation
  static const String navHome = 'assets/images/home.png';
  static const String navOrders = 'assets/images/location.png';
  static const String navCategory = 'assets/images/apps.png';
  static const String navSupport = 'assets/images/headphones.png';
  static const String navProfile = 'assets/images/user_profile.png';

  //*TODO:: DummyJSON product API.
  static const String productsUrl =
      'https://dummyjson.com/products';

  //*TODO:: How long we wait for the API before showing an error.
  static const Duration apiTimeout = Duration(seconds: 15);

  //*TODO:: API gives prices in USD, so we convert them to PKR.
  static const double usdToPkr = 280;

  //*TODO:: Fixed shipping fee added to every order.
  static const double shippingFee = 200;

  //*TODO:: Promo code that gives 10% off.
  static const String validPromo = 'FASHION10';
  static const double promoDiscount = 0.10;

  //*TODO:: Sizes shown on the product detail screen.
  static const List<String> sizes = ['S', 'M', 'L', 'XL'];
  static const String defaultSize = 'M';

  //*TODO:: Fashion categories shown in the app.
  static const List<String> categories = [
    'All',
    'Dresses',
    'Shirts',
    'Shoes',
    'Bags',
    'Accessories',
  ];
}