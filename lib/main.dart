import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ms_shopping/Screen/Home_Screen.dart';
import 'package:ms_shopping/Screen/login_Screen.dart';
import 'package:ms_shopping/Selection/Selection_Screen.dart';
import 'package:ms_shopping/model/CartProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
              home: FirebaseAuth.instance.currentUser != null
                  ? const HomeScreen()
                  : const LoginScreen()
          );
        },
      ),
    );
  }
}
