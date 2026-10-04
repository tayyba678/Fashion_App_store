import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/cart_item_model.dart';
import '../providers/cart_provider.dart';
import '../utils/app_constants.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
//*TODO:: Read all products currently stored in the cart.
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.homeBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

//*TODO:: Build the scrollable upper cart product area.
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  width: double.infinity,
                  color: AppColors.homeBg,
                  padding: EdgeInsets.only(
                    left: 27.w,
                    right: 27.w,
                    bottom: 28.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBackButton(context),

                      SizedBox(height: 56.h),

//*TODO:: Display every product currently added to the cart.
                      ...cartItems.asMap().entries.map(
                        (entry) {
                          final index = entry.key;
                          final cartItem = entry.value;

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: 24.h,
                            ),
                            child: _buildProductSection(
                              context: context,
                              cartItem: cartItem,
                              index: index,
                              ref: ref,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

//*TODO:: Keep the white checkout summary area fixed at the bottom.
            _buildCheckoutSection(
              cartItems: cartItems,
            ),
          ],
        ),
      ),
    );
  }

//*TODO:: Build the checkout header.
  Widget _buildHeader() {
    return SizedBox(
      height: 60.h,
      child: Row(
        children: [
          SizedBox(width: 30.w),

          Text(
            AppStrings.appName,
            style: TextStyle(
              fontFamily: AppStrings.fontFamilyLato,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

//*TODO:: Display the cart image.
          Image.asset(
            AppStrings.cartIcon,
            width: 24.w,
            height: 24.h,
            fit: BoxFit.contain,
          ),

          SizedBox(width: 24.w),

          const Icon(
            Icons.menu,
            size: 24,
          ),

          SizedBox(width: 27.w),
        ],
      ),
    );
  }

//*TODO:: Build the back button.
  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 38.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(9.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.arrow_back,
          size: 20.sp,
        ),
      ),
    );
  }

//*TODO:: Build an individual cart product section.
  Widget _buildProductSection({
    required BuildContext context,
    required CartItem cartItem,
    required int index,
    required WidgetRef ref,
  }) {
    final product = cartItem.product;
    final quantity = cartItem.quantity;
    final selectedSize = cartItem.selectedSize;

//*TODO:: Use the image selected by the user on the product detail screen.
    final imageIndex = cartItem.selectedImageIndex < product.images.length
        ? cartItem.selectedImageIndex
        : 0;

    final imageUrl =
        product.images.isNotEmpty ? product.images[imageIndex] : product.image;

//*TODO:: Calculate the price for this cart item.
    final totalPrice = product.price * AppConstants.usdToPkr * quantity;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//*TODO:: Display the selected product image.
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            imageUrl,
            width: 77.w,
            height: 77.h,
            fit: BoxFit.cover,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return Container(
                width: 77.w,
                height: 77.h,
                color: AppColors.white,
                child: const Icon(
                  Icons.image_not_supported,
                ),
              );
            },
          ),
        ),

        SizedBox(width: 15.w),

//*TODO:: Display product information and quantity controls.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyLato,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '${AppStrings.currency}${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyLato,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
//*TODO:: Decrease the quantity of this specific cart item.
                  _buildQuantityButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (quantity > 1) {
                        ref.read(cartProvider.notifier).updateQuantity(
                              index,
                              quantity - 1,
                            );
                      }
                    },
                  ),

                  SizedBox(width: 8.w),

                  Text(
                    '$quantity',
                    style: TextStyle(
                      fontFamily: AppStrings.fontFamilyLato,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(width: 8.w),

//*TODO:: Increase the quantity of this specific cart item.
                  _buildQuantityButton(
                    icon: Icons.add,
                    onTap: () {
                      ref.read(cartProvider.notifier).updateQuantity(
                            index,
                            quantity + 1,
                          );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(width: 15.w),

//*TODO:: Keep size on top and delete below it.
        SizedBox(
          width: 30.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                selectedSize,
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyLato,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 24.h),

//*TODO:: Remove only this product from the cart.
              GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier).removeFromCart(index);
                },
                child: Image.asset(
                  AppStrings.deleteIcon,
                  width: 21.w,
                  height: 21.h,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//*TODO:: Build the quantity button.
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 19.w,
        height: 19.h,
        decoration: BoxDecoration(
          color: AppColors.homeBg,
          borderRadius: BorderRadius.circular(5.r),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 13.sp,
        ),
      ),
    );
  }

//*TODO:: Build the checkout summary section.
  Widget _buildCheckoutSection({
    required List<CartItem> cartItems,
  }) {
//*TODO:: Calculate the subtotal of all products in the cart.
    final subtotal = cartItems.fold<double>(
      0,
      (sum, item) {
        return sum + item.product.price * AppConstants.usdToPkr * item.quantity;
      },
    );

    const shipping = 0.0;

    final bagTotal = subtotal + shipping;

    return Container(
      width: double.infinity,
      height: 402.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 27.w,
          right: 27.w,
          top: 20.h,
          bottom: 16.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//*TODO:: Build the promo code field.
            SizedBox(height: 20.h),

            _buildPromoCode(),

            SizedBox(height: 43.h),

//*TODO:: Display subtotal.
            _buildPriceRow(
              title: AppStrings.subTotal,
              price: subtotal,
            ),

            SizedBox(height: 30.h),

//*TODO:: Display shipping.
            _buildPriceRow(
              title: AppStrings.shipping,
              price: shipping,
            ),

            SizedBox(height: 30.h),

//*TODO:: Display total bag price.
            _buildPriceRow(
              title: AppStrings.bagTotal,
              price: bagTotal,
            ),

            SizedBox(height: 40.h),

//*TODO:: Build the proceed button.
            _buildProceedButton(),
          ],
        ),
      ),
    );
  }

//*TODO:: Build the promo code text field with the Apply button.
  Widget _buildPromoCode() {
    return SizedBox(
      width: 376.w,
      height: 56.h,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
//*TODO:: Build the editable promo code field.
          TextField(
            decoration: InputDecoration(
              hintText: AppStrings.promoCodeHint,
              hintStyle: TextStyle(
                fontFamily: AppStrings.fontFamilyLato,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.hintText,
              ),
              filled: true,
              fillColor: AppColors.homeBg,
              contentPadding: EdgeInsets.only(
                left: 18.w,
                right: 110.w,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),

//*TODO:: Place the Apply button over the promo field.
          Positioned(
            right: 0,
            top: 3.h,
            child: GestureDetector(
              onTap: () {
//*TODO:: Apply the entered promo code.
              },
              child: Container(
                width: 99.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.bottomNav,
                  borderRadius: BorderRadius.circular(9.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.apply,
                  style: TextStyle(
                    fontFamily: AppStrings.fontFamilyLato,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//*TODO:: Build the price summary row.
  Widget _buildPriceRow({
    required String title,
    required double price,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppStrings.fontFamilyLato,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            height: 1,
            color: AppColors.greyText,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
            ),
            child: Row(
              children: List.generate(
                20,
                (index) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                    ),
                    child: Container(
                      height: 1,
                      color: AppColors.divider,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(
          '${AppStrings.currency}${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontFamily: AppStrings.fontFamilyLato,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            height: 1,
            color: AppColors.greyText,
          ),
        ),
      ],
    );
  }

//*TODO:: Build the proceed to checkout button.
  Widget _buildProceedButton() {
    return Container(
      width: double.infinity,
      height: 78.h,
      decoration: BoxDecoration(
        color: AppColors.bottomNav,
        borderRadius: BorderRadius.circular(17.r),
      ),
      alignment: Alignment.center,
      child: Text(
        AppStrings.checkout,
        style: TextStyle(
          fontFamily: AppStrings.fontFamilyLato,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
          color: AppColors.white,
        ),
      ),
    );
  }
}
