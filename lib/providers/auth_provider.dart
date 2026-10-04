import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

//TODO:: Store authentication-related state.
class AuthState {
  final bool isLoading;

  const AuthState({
    this.isLoading = false,
  });

//TODO:: Create a new authentication state.
  AuthState copyWith({
    bool? isLoading,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

//TODO:: Manage authentication actions through Riverpod.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

//TODO:: Handle Google Sign-In.
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);

    try {
      await AuthService().signInWithGoogle();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

//TODO:: Handle email/password login.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      await AuthService().signInWithEmail(
        email: email,
        password: password,
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

//TODO:: Handle new account creation.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      await AuthService().createAccount(
        name: name,
        email: email,
        password: password,
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

//TODO:: Provide authentication state to the application.
final authProvider =
NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

//TODO:: Listen to Firebase authentication changes.
final authStateProvider = StreamProvider<User?>((ref) {
  return AuthService().authStateChanges;
});

//TODO:: Store password visibility state separately from authentication state.
class PasswordVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

//TODO:: Toggle password visibility.
  void toggle() {
    state = !state;
  }
}

//TODO:: Provide password visibility state.
final passwordVisibilityProvider =
NotifierProvider<PasswordVisibilityNotifier, bool>(
  PasswordVisibilityNotifier.new,
);
