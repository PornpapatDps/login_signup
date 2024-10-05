import 'package:flutter/material.dart';
// import 'pages/transaction.dart';
// import 'database/model.dart';
import 'pages/login.dart';
//
// *** Edit #1 *** => import plug-in
import 'package:firebase_core/firebase_core.dart';
// import 'database/database_helper.dart';
//

Future<void> main() async {
  //
  // *** Edit #2 *** => Modify main to init firebase plug-in
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyBGGpdWQJrYZqGRW_GH-FaEeHlEc1VDR5M", 
    appId: "1:107350833577:android:25ac541d796fb3cb692cb8", 
    messagingSenderId: "", 
    projectId: "income-and-expense-app-e9b5d")
  );
  //
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      
      home: LoginScreen(
        
      ),
    );
  }
}