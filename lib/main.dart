// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:notepad/settings_page.dart';
import 'firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init(cacheProvider: SharePreferenceCache());
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
    final isDarkMode = Settings.getValue<bool>(SettingsPage.keyDarkMode, true);

    return ValueChangeObserver<bool>(
      cacheKey: SettingsPage.keyDarkMode,
      defaultValue: false,
      builder: (_, isDarkMode, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notepad',
        theme: isDarkMode ? ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          //colorScheme: ColorScheme.dark().copyWith(secondary: Colors.white),
          scaffoldBackgroundColor: Color(0xFF102A43),
          canvasColor: Color(0xFF102A43),
        )
        : ThemeData.light().copyWith(accentColor: Colors.black),
        home: const LoginPage(),
      ),
    );
  }
}
