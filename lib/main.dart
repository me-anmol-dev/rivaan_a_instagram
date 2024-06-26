import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rivaan_a_instagram/providers/user_provider.dart';

import 'package:rivaan_a_instagram/responsive/mobile_screen_layout.dart';
import 'package:rivaan_a_instagram/responsive/responsive_layout_screen.dart';
import 'package:rivaan_a_instagram/responsive/web_screen_layout.dart';
import 'package:rivaan_a_instagram/screens/login_screen.dart';
import 'package:rivaan_a_instagram/screens/signup_screen.dart';
import 'package:rivaan_a_instagram/utilities/color.dart';
import './screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBX7RuVoIRaglVnddjUwp9Z-RikFm-pPpY",
        appId: "1:700394767322:web:7d47a31ec385ba0616f6e3",
        messagingSenderId: "700394767322",
        projectId: "rivaan-ad910",
        storageBucket: "rivaan-ad910.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // MultiProvider(
        // providers: [
        //   ChangeNotifierProvider(
        //     create: (_) => UserProvider(),
        //   ),
        // ],
        // child:
        MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
        useMaterial3: true,
        typography: Typography.material2021(platform: TargetPlatform.android),
        splashFactory: InkSparkle.splashFactory,
      ),
      // home: const ResponsiveLayout(
      //   webScreenLayout: WebScreenLayout(),
      //   mobileScreenLayout: MobileScreenLayout(),
      // home: const LoginScreen(),
      routes: {
        SignupScreen.routeTo: (context) => const SignupScreen(),
        LoginScreen.routeTo: (context) => const LoginScreen(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Checking if the snapshot has any data or not
            if (snapshot.hasData) {
              // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
              return const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }

          // means connection to future hasn't been made yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
