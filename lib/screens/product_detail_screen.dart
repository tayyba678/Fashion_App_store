import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../screens/checkout_screen.dart';
import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_strings.dart';

class ProductDetailScreen extends ConsumerWidget {
  final ProductModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImageIndex = ref.watch(selectedImageIndexProvider(product.id));
    final selectedImage = product.images.isNotEmpty && selectedImageIndex < product.images.length
        ? product.images[selectedImageIndex]
        : product.image;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 90.h),
            child: Column(
              children: [
                _buildProductImageSection(product, ref, selectedImage, selectedImageIndex),
                _buildProductInformation(product, ref),
              ],
            ),
          ),
          Positioned(
            top: 55.h,
            left: 24.w,
            right: 24.w,
            child: _buildHeader(),
          ),
          Positioned(
            left: 24.w,
            right: 24.w,
            bottom: 20.h,
            child: _buildQuantityAndBuyRow(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImageSection(ProductModel product, WidgetRef ref, String selectedImage, int selectedImageIndex) {
    final thumbnails = product.images.take(4).toList();

    return SizedBox(
      width: 430.w,
      height: 645.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              selectedImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.image_not_supported, size: 50),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20.h,
            child: _buildThumbnailSelector(ref, thumbnails, selectedImageIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAppName(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIconBox(AppStrings.cartIcon),
            SizedBox(width: 12.w),
            _buildIconBox(AppConstants.menuIcon),
          ],
        ),
      ],
    );
  }

  Widget _buildAppName() {
    return Text(
      AppStrings.appName,
      style: TextStyle(
        fontFamily: AppStrings.fontFamilyLato,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        height: 1,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildIconBox(String asset) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildThumbnailSelector(WidgetRef ref, List<String> thumbnails, int selectedImageIndex) {
    if (thumbnails.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: 430.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Row(
              children: List.generate(
                thumbnails.length,
                (index) {
                  final isSelected = index == selectedImageIndex;
                  return Container(
                    width: isSelected ? 11.w : 7.w,
                    height: isSelected ? 11.h : 7.h,
                    margin: EdgeInsets.only(right: index == thumbnails.length - 1 ? 0 : 6.w),
                    decoration: const BoxDecoration(color: AppColors.black, shape: BoxShape.circle),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: Row(
              children: List.generate(
                thumbnails.length,
                (index) {
                  final image = thumbnails[index];
                  final isSelected = index == selectedImageIndex;
                  return GestureDetector(
                    onTap: () => ref.read(selectedImageIndexProvider(product.id).notifier).state = index,
                    child: Container(
                      width: isSelected ? 50.w : 48.w,
                      height: isSelected ? 50.h : 48.h,
                      margin: EdgeInsets.only(right: index == thumbnails.length - 1 ? 0 : 8.w),
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        borderRadius: BorderRadius.circular(isSelected ? 17.r : 15.r),
                        border: Border.all(color: AppColors.black, width: 2.w),
                      ),
                      padding: isSelected ? EdgeInsets.all(1.w) : EdgeInsets.zero,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(isSelected ? 14.r : 13.r),
                        child: Image.network(
                          image,
                          width: 44.w,
                          height: 44.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInformation(ProductModel product, WidgetRef ref) {
    final quantity = ref.watch(quantityProvider(product.id));
    final priceInPkr = product.price * AppConstants.usdToPkr * quantity;

    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 28.h, bottom: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style: TextStyle(
                    fontFamily: AppStrings.fontFamilyLato,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '${AppStrings.currency}${priceInPkr.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyLato,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: AppColors.priceBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Text(
            AppStrings.detailsLabel,
            style: TextStyle(
              fontFamily: AppStrings.fontFamilyLato,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              height: 1,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            product.description,
            style: TextStyle(
              fontFamily: AppStrings.fontFamilyLato,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              letterSpacing: 0.24.sp,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 212.w,
                child: Text(
                  AppStrings.colorsLabel,
                  style: TextStyle(
                    fontFamily: AppStrings.fontFamilyLato,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: AppColors.black,
                  ),
                ),
              ),
              Text(
                AppStrings.sizeLabel,
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyLato,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 212.w, child: _buildColorSelector(ref, product.id)),
              _buildSizeSelector(ref, product.id),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelector(WidgetRef ref, int productId) {
    final colors = [AppColors.grey, AppColors.badge];
    final selectedColorIndex = ref.watch(selectedColorProvider(productId));

    return Row(
      children: List.generate(
        colors.length,
        (index) {
          final isSelected = index == selectedColorIndex;
          return GestureDetector(
            onTap: () => ref.read(selectedColorProvider(productId).notifier).state = index,
            child: Container(
              width: 46.w,
              height: 46.h,
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(isSelected ? 2.w : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected ? Border.all(color: AppColors.black, width: 2.w) : null,
              ),
              child: Container(decoration: BoxDecoration(color: colors[index], shape: BoxShape.circle)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSizeSelector(WidgetRef ref, int productId) {
    const sizes = [AppStrings.sizeS, AppStrings.sizeM, AppStrings.sizeL];
    final selectedSizeIndex = ref.watch(selectedSizeProvider(productId));

    return Row(
      children: List.generate(
        sizes.length,
        (index) {
          final isSelected = index == selectedSizeIndex;
          return GestureDetector(
            onTap: () => ref.read(selectedSizeProvider(productId).notifier).state = index,
            child: Container(
              width: 46.w,
              height: 46.h,
              margin: EdgeInsets.only(right: index == sizes.length - 1 ? 0 : 10.w),
              padding: EdgeInsets.all(isSelected ? 2.w : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected ? Border.all(color: AppColors.black, width: 2.w) : null,
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.pink, shape: BoxShape.circle),
                child: Text(
                  sizes[index],
                  style: TextStyle(
                    fontFamily: AppStrings.fontFamilyLato,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuantityAndBuyRow(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(quantityProvider(product.id));

    return Container(
      width: double.infinity,
      height: 48.h,
      color: AppColors.white,
      child: Row(
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onTap: () {
              if (quantity > 1) {
                ref.read(quantityProvider(product.id).notifier).state = quantity - 1;
              }
            },
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 18.w,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppStrings.fontFamilyLato,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          _buildQuantityButton(
            icon: Icons.add,
            onTap: () => ref.read(quantityProvider(product.id).notifier).state = quantity + 1,
          ),
          const Spacer(),
          SizedBox(
            width: 156.w,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                const sizes = [AppStrings.sizeS, AppStrings.sizeM, AppStrings.sizeL];
                final selectedSizeIndex = ref.read(selectedSizeProvider(product.id));
                final selectedSize = sizes[selectedSizeIndex];
                final selectedImageIndex = ref.read(selectedImageIndexProvider(product.id));

                ref.read(cartProvider.notifier).addToCart(CartItem(
                      product: product,
                      quantity: quantity,
                      selectedSize: selectedSize,
                      selectedImageIndex: selectedImageIndex,
                    ));

                Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionButton,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.r)),
              ),
              child: Text(
                AppStrings.buyNow,
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyLato,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.quantityBackground,
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Icon(icon, color: AppColors.white, size: 20.sp),
      ),
    );
  }
}
