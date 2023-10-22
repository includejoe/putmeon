import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/presentation/screens/main_screen.dart';
import 'package:jobpulse/base/presentation/theme/theme_constants.dart';
import 'package:jobpulse/base/presentation/theme/theme_provider.dart';
import 'package:jobpulse/base/providers/user_provider.dart';
import 'package:jobpulse/user/presentation/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  loadAppResources();
  runApp(const MyApp());
}


// function to run before splash screen is done
void loadAppResources({BuildContext? context}) async {
  initialize();
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Dev Opportunity",
              themeMode: themeProvider.themeMode,
              theme: lightTheme,
              darkTheme: darkTheme,
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return const MainScreen(); // return main screen
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("${snapshot.error}"),
                      );
                    }
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  return const LoginScreen(); // return login screen
                },
              )
          );
        },
      )
    );
  }
}