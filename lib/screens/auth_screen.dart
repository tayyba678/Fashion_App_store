import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

//TODO:: Screen used for email/password login and signup.
class AuthScreen extends ConsumerStatefulWidget {
  final bool isLogin;

  const AuthScreen({
    super.key,
    required this.isLogin,
  });

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

//TODO:: Handle login or signup.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(authProvider.notifier);

    try {
      if (widget.isLogin) {
        await notifier.login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await notifier.signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final obscurePassword = ref.watch(passwordVisibilityProvider);

    return Scaffold(
      backgroundColor: AppColors.welcomeBg,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 30),
                  if (!widget.isLogin) ...[
                    _buildNameField(),
                    const SizedBox(height: 16),
                  ],
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(obscurePassword),
                  const SizedBox(height: 28),
                  _buildSubmitButton(authState.isLoading),
                  const SizedBox(height: 20),
                  _buildSwitchAuth(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//TODO:: Build app bar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.welcomeBg,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: AppColors.black,
      ),
    );
  }

//TODO:: Build screen title.
  Widget _buildTitle() {
    return Center(
      child: Text(
        widget.isLogin ? AppStrings.logIn : AppStrings.signUp,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
    );
  }

//TODO:: Build full name field.
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        label: AppStrings.fullName,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.valEnterName;
        }

        return null;
      },
    );
  }

//TODO:: Build email field.
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        label: AppStrings.email,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.valEnterEmail;
        }

        if (!value.contains('@')) {
          return AppStrings.valValidEmail;
        }

        return null;
      },
    );
  }

//TODO:: Build password field.
  Widget _buildPasswordField(bool obscurePassword) {
    return TextFormField(
      controller: _passwordController,
      obscureText: obscurePassword,
      textInputAction: TextInputAction.done,
      decoration: _inputDecoration(
        label: AppStrings.password,
        suffixIcon: IconButton(
          onPressed: () {
            ref.read(passwordVisibilityProvider.notifier).toggle();
          },
          icon: Icon(
            obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.valEnterPassword;
        }

        if (value.length < 6) {
          return AppStrings.valPasswordLength;
        }

        return null;
      },
      onFieldSubmitted: (_) => _submit(),
    );
  }

//TODO:: Build login/signup button.
  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.isLogin ? AppStrings.logIn : AppStrings.signUp,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

//TODO:: Build switch between login and signup.
  Widget _buildSwitchAuth() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AuthScreen(
                isLogin: !widget.isLogin,
              ),
            ),
          );
        },
        child: Text(
          widget.isLogin ? AppStrings.createNewAccount : AppStrings.alreadyHaveAccount,
          style: const TextStyle(
            color: AppColors.black,
          ),
        ),
      ),
    );
  }

//TODO:: Build common input decoration.
  InputDecoration _inputDecoration({
    required String label,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
    );
  }
}
