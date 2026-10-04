import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'utils/app_strings.dart';

//TODO:: Initialize Firebase and start the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: FashionApp(),
    ),
  );
}

//TODO:: Main application widget.
class FashionApp extends ConsumerWidget {
  const FashionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          home: const AuthGate(),
        );
      },
    );
  }
}

//TODO:: Decide which screen should be shown based on Firebase login state.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
//TODO:: Show a simple loading screen while Firebase checks the session.
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),

//TODO:: Show WelcomeScreen if authentication state cannot be loaded.
      error: (error, stackTrace) => const WelcomeScreen(),

//TODO:: Open the correct screen based on the logged-in user.
      data: (user) {
        if (user == null) {
          return const WelcomeScreen();
        }

//TODO:: Replace this temporary screen with the actual HomeScreen.
        return const HomeScreen();

      },
    );
  }
}
