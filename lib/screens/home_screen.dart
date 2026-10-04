import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_strings.dart';
import 'product_detail_screen.dart';

//TODO:: Home screen of the Fashion app.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  //TODO:: Filter products according to the selected fashion category.
  List<ProductModel> _filterProducts(
      List<ProductModel> products,
      String selectedCategory,
      ) {
    if (selectedCategory == AppStrings.categoryAll) {
      return products;
    }

    if (selectedCategory == AppStrings.categoryDresses) {
      return products
          .where(
            (product) => product.category == 'womens-dresses',
      )
          .toList();
    }

    if (selectedCategory == AppStrings.categoryShirts) {
      return products
          .where(
            (product) => product.category == 'mens-shirts',
      )
          .toList();
    }

    if (selectedCategory == AppStrings.categoryShoes) {
      return products
          .where(
            (product) =>
        product.category == 'mens-shoes' ||
            product.category == 'womens-shoes',
      )
          .toList();
    }

    if (selectedCategory == AppStrings.categoryBags) {
      return products
          .where(
            (product) => product.category == 'womens-bags',
      )
          .toList();
    }

    if (selectedCategory == AppStrings.categoryAccessories) {
      return products
          .where(
            (product) =>
        product.category == 'mens-watches' ||
            product.category == 'womens-watches' ||
            product.category == 'womens-jewellery' ||
            product.category == 'sunglasses',
      )
          .toList();
    }

    return products;
  }

  //TODO:: Filter products according to the search query.
  List<ProductModel> _searchProducts(
      List<ProductModel> products,
      String searchQuery,
      ) {
    if (searchQuery.trim().isEmpty) {
      return products;
    }

    final query = searchQuery.trim().toLowerCase();

    return products.where((product) {
      return product.title.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: AppColors.homeBg,
      body: SizedBox(
        width: 430.w,
        height: 932.h,
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(ref),
                Expanded(
                  child: products.when(
                    //TODO:: Show a loader until all products are fetched.
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: AppColors.black,
                        strokeWidth: 2.5.w,
                      ),
                    ),

                    //TODO:: Show an error when products cannot be loaded.
                    error: (error, stackTrace) {
                      return _buildErrorState(ref);
                    },

                    //TODO:: Show the complete product content after loading finishes.
                    data: (productList) {
                      return _buildProductContent(
                        context,
                        ref,
                        productList,
                      );
                    },
                  ),
                ),
              ],
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  //TODO:: Header containing app name, cart, menu and search bar.
  Widget _buildHeader(WidgetRef ref) {
    return Container(
      width: 430.w,
      height: 176.h,
      color: AppColors.homeHeaderBg,
      padding: EdgeInsets.only(
        top: 55.h,
        left: 24.w,
        right: 24.w,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAppName(),
              Row(
                children: [
                  _buildCartButton(),
                  SizedBox(width: 12.w),
                  _buildIconBox(AppConstants.menuIcon),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildSearchBar(ref),
        ],
      ),
    );
  }

  //TODO:: Build Fashion app name.
  Widget _buildAppName() {
    return Text(
      AppStrings.appName,
      style: TextStyle(
        fontFamily: AppStrings.fontFamilyLato,
        fontSize: 24.sp,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        height: 1,
        color: AppColors.black,
      ),
    );
  }

  //TODO:: Build cart icon with item count.
  Widget _buildCartButton() {
return _buildIconBox(AppConstants.cartIcon);
}

  //TODO:: Build common icon container.
  Widget _buildIconBox(String asset) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Image.asset(
          asset,
          width: 20.w,
          height: 20.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  //TODO:: Build searchable product field.
  Widget _buildSearchBar(WidgetRef ref) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Image.asset(
            AppConstants.searchIcon,
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: TextField(
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              style: TextStyle(
                fontFamily: AppStrings.fontFamilyInter,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1,
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.search,
                hintStyle: TextStyle(
                  fontFamily: AppStrings.fontFamilyInter,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          Image.asset(
            AppConstants.dividerIcon,
            height: 18.h,
          ),
          SizedBox(width: 10.w),
          Image.asset(
            AppConstants.filterIcon,
            width: 18.w,
            height: 18.h,
          ),
        ],
      ),
    );
  }

  //TODO:: Build product content below the header.
  Widget _buildProductContent(
      BuildContext context,
      WidgetRef ref,
      List<ProductModel> products,
      ) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final categoryProducts = _filterProducts(
      products,
      selectedCategory,
    );

    final items = _searchProducts(
      categoryProducts,
      searchQuery,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: 130.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategories(ref),
          SizedBox(height: 49.h),
          _buildAllCollection(),
          SizedBox(height: 40.h),
          _buildProductGrid(
            context,
            items,
          ),
        ],
      ),
    );
  }

  //TODO:: Build category tabs.
  Widget _buildCategories(WidgetRef ref) {
    final categories = AppConstants.categories;
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 32.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: categories.length,
        separatorBuilder: (_, __) {
          return SizedBox(width: 8.w);
        },
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state =
                  category;
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.selectedTab
                    : AppColors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyInter,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  color: AppColors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //TODO:: Build All Collection text.
  Widget _buildAllCollection() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 24.w),
        child: Text(
          AppStrings.allCollection,
          style: TextStyle(
            fontFamily: AppStrings.fontFamilyInter,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 1,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }

  //TODO:: Build two-column dynamic product grid.
  Widget _buildProductGrid(
      BuildContext context,
      List<ProductModel> products,
      ) {
    final leftProducts = <ProductModel>[];
    final rightProducts = <ProductModel>[];

    for (int index = 0; index < products.length; index++) {
      if (index.isEven) {
        leftProducts.add(products[index]);
      } else {
        rightProducts.add(products[index]);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: leftProducts
                .map(
                  (product) => _buildProductCard(
                context,
                product,
              ),
            )
                .toList(),
          ),
          Column(
            children: rightProducts
                .map(
                  (product) => _buildProductCard(
                context,
                product,
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  //TODO:: Build one dynamic product card.
  Widget _buildProductCard(
      BuildContext context,
      ProductModel product,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: SizedBox(
        width: 180.w,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ProductDetailScreen(
                    product: product,
                  );
                },
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(product),
              SizedBox(height: 18.h),
              _buildProductTitle(product),
              SizedBox(height: 15.h),
              _buildProductPrice(product),
            ],
          ),
        ),
      ),
    );
  }

//TODO:: Build product image with flexible height and heart icon.
  Widget _buildProductImage(ProductModel product) {
    return Container(
      width: 180.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            product.images.isNotEmpty
                ? product.images.first
                : product.image,
            width: 180.w,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.image_not_supported),
              );
            },
          ),
          //TODO:: Show the heart icon at the bottom-right of the product image.
          Positioned(
            bottom: 12.h,
            right: 12.w,
            child: Container(
              width: 42.w,
              height: 42.h,
              decoration: const BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                color: AppColors.white,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
  //TODO:: Build product title.
  Widget _buildProductTitle(ProductModel product) {
    return Text(
      product.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: AppStrings.fontFamilyLato,
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        height: 1,
        color: AppColors.black,
      ),
    );
  }

  //TODO:: Build product price in Pakistani Rupees.
  Widget _buildProductPrice(ProductModel product) {
    final priceInPkr = product.price * AppConstants.usdToPkr;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${AppStrings.currency}${priceInPkr.toStringAsFixed(0)}',
          style: TextStyle(
            fontFamily: AppStrings.fontFamilyLato,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            height: 1,
            color: AppColors.black,
          ),
        ),
        Image.asset(
          AppConstants.cartIcon,
          width: 18.w,
          height: 18.h,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  //TODO:: Build product loading error state.
  Widget _buildErrorState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            AppStrings.productsError,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(productProvider);
            },
            child: const Text(
              AppStrings.retry,
            ),
          ),
        ],
      ),
    );
  }

  //TODO:: Build floating bottom navigation.
  Widget _buildBottomNav() {
    final icons = [
      AppConstants.navHome,
      AppConstants.navOrders,
      AppConstants.navCategory,
      AppConstants.navSupport,
      AppConstants.navProfile,
    ];

    return Positioned(
      top: 830.h,
      left: 15.w,
      child: Container(
        width: 400.w,
        height: 77.h,
        decoration: BoxDecoration(
          color: AppColors.bottomNav,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: icons.map(
                (icon) {
              return Image.asset(
                icon,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
