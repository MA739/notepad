import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //declare class from imported file

  runApp(MyApp());
}

//creates instance of imported FireBaseService Class
FirebaseService service = FirebaseService();
//FirebaseStorage storage = FirebaseStorage.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
