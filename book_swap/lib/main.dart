import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/app_colors.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'BookSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: authState.when(
        data: (user) => user != null ? const MainScreen() : const LoginScreen(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const LoginScreen(),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'firebase_options.dart';

// import 'core/constants/app_colors.dart';
// import 'presentation/providers/auth_provider.dart';
// import 'presentation/providers/book_provider.dart';
// import 'presentation/providers/swap_provider.dart';
// import 'presentation/providers/chat_provider.dart';
// import 'presentation/screens/auth/sign_in_screen.dart';
// import 'presentation/screens/main_screen.dart';

//   Future<void> main() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//       );
//   runApp(BookSwapApp());
// }

// class BookSwapApp extends StatelessWidget {
//   const BookSwapApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Multi-provider setup for state management
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => BookProvider()),
//         ChangeNotifierProvider(create: (_) => SwapProvider()),
//         ChangeNotifierProvider(create: (_) => ChatProvider()),
//       ],
//       child: MaterialApp(
//         title: 'BookSwap',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primaryColor: AppColors.primary,
//           scaffoldBackgroundColor: AppColors.background,
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: AppColors.primary,
//             brightness: Brightness.light,
//           ),
//           useMaterial3: true,
//         ),
//         // Check authentication state and route accordingly
//         home: Consumer<AuthProvider>(
//           builder: (context, authProvider, _) {
//             // Listen to auth state changes
//             return StreamBuilder(
//               stream: authProvider.authStateChanges,
//               builder: (context, snapshot) {
//                 // Show loading while checking auth state
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Scaffold(
//                     body: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 }
                
//                 // Navigate based on authentication status
//                 if (snapshot.hasData) {
//                   return const MainScreen();
//                 } else {
//                   return const SignInScreen();
//                 }
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }