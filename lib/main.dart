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
    final isDarkMode = Settings.getValue<bool>(HeaderPage.keyDarkMode, ture);
    return ValueChangeObserver<bool>(
      cacheKey: HeaderPage.keyDarkMode,
      defaultValue: true,
      builder: (_, isDarkMode, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.teal,
          accentColor: Colors.white,
          scaffoldBackgroundColor: Color(0xFF170635),
          canvasColor: Color(0xFF170635),
        ),
        : ThemeData.light().copyWith(accentColor: Colors.black),
        home: SettingsPage(),
      ), // MaterialApp
    ); // ValueChangeObserver
  }
}
