import 'package:chat_app/features/auth/presentation/auth_page.dart';
import 'package:chat_app/features/home/chat_page.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        AuthPage.routeName: (context) => const AuthPage(),
        ChatPage.routeName: (context) => const ChatPage(),
      },
      initialRoute: AuthPage.routeName,
      // home: const SignInScreen(),
    );
  }
}
