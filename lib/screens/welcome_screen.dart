import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_strings.dart';
import 'auth_screen.dart';

//TODO:: First screen shown when the user opens the Fashion app.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

//TODO:: Open login or signup screen.
  void _openAuth(BuildContext context, bool isLogin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AuthScreen(isLogin: isLogin),
      ),
    );
  }

//TODO:: Handle Google Sign-In.
  Future<void> _googleSignIn(
      BuildContext context,
      WidgetRef ref,
      ) async {
    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              AppStrings.googleSignInFailed,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.welcomeBg,
      body: SizedBox(
        width: 430.w,
        height: 932.h,
        child: Stack(
          children: [
            _buildAppName(),
            _buildWelcomeImage(),
            _buildAuthLinks(context),
            _buildGoogleButton(
              context,
              ref,
              authState.isLoading,
            ),
            _buildGetStartedButton(context),
            if (authState.isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  //TODO:: Build Fashion app name.
  Widget _buildAppName() {
    return Positioned(
      top: 80.h,
      left: 0,
      right: 0,
      child: Text(
        AppStrings.appName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppStrings.fontFamilyLato,
          fontSize: 24.sp,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          height: 1,
          letterSpacing: 0,
          color: AppColors.black,
        ),
      ),
    );
  }

//TODO:: Build welcome image.
  Widget _buildWelcomeImage() {
    return Positioned(
      top: 127.h,
      left: 38.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(42.r),
        child: Image.asset(
          AppConstants.welcomeImage,
          width: 354.w,
          height: 590.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

//TODO:: Build Sign Up and Log In links.
  Widget _buildAuthLinks(BuildContext context) {
    return Positioned(
      top: 751.h,
      left: 162.w,
      child: SizedBox(
        width: 106.w,
        height: 17.h,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _openAuth(context, false),
                child: Text(
                  AppStrings.signUp,
                  style: TextStyle(
                    fontFamily: AppStrings.fontFamilyLato,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' ${AppStrings.or} ',
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyLato,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () => _openAuth(context, true),
                child: Text(
                  AppStrings.logIn,
                  style: TextStyle(
                    fontFamily: AppStrings.fontFamilyLato,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//TODO:: Build Google Sign-In button.
  Widget _buildGoogleButton(
      BuildContext context,
      WidgetRef ref,
      bool isLoading,
      ) {
    return Positioned(
      top: 802.h,
      left: 38.w,
      child: InkWell(
        onTap: isLoading
            ? null
            : () => _googleSignIn(context, ref),
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: 79.w,
          height: 79.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Center(
            child: Image.asset(
              AppConstants.googleImage,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  //TODO:: Build full-screen loading overlay.
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        color: AppColors.loadingOverlay,
        child: Center(
          child: SizedBox(
            width: 35.w,
            height: 35.h,
            child: CircularProgressIndicator(
              strokeWidth: 3.w,
            ),
          ),
        ),
      ),
    );
  }

//TODO:: Build Get Started button.
  Widget _buildGetStartedButton(BuildContext context) {
    return Positioned(
      top: 802.h,
      left: 129.w,
      child: InkWell(
        onTap: () => _openAuth(context, false),
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: 263.w,
          height: 79.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.getStarted,
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyLato,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: AppColors.black,
                ),
              ),
              SizedBox(width: 10.w),
              Image.asset(
                AppConstants.arrowImage,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
