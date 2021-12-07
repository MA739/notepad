// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

FirebaseService service = FirebaseService();

class SettingsPage extends StatefulWidget {
  static const keyDarkMode = 'key-dark-mode';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Route route = MaterialPageRoute(builder: (context) => const LoginPage());
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
          elevation: 2,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              SettingsGroup(
                title: 'GENERAL',
                children: <Widget>[
                  buildDarkMode(),
                  buildLogout(),
                ],
              ),
              const SizedBox(height: 32),
              SettingsGroup(
                title: 'FEEDBACK',
                children: <Widget>[
                  const SizedBox(height: 8),
                  buildReportBug(context),
                  buildSendFeedback(context),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildLogout() => SimpleSettingsTile(
      title: 'Logout',
      subtitle: '',
      leading: const Icon(Icons.logout, color: Colors.blueAccent),
      onTap: () {
        showDialog<String>(
            //confirm user signout
            context: context,
            builder: (BuildContext context) => AlertDialog(
                    content: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                          //This is where it would navigate to the actual app's content
                          onPressed: () => {Navigator.pop(context)},
                          child: const Text('No')),
                      TextButton(
                          //This is where it would navigate to the actual app's content
                          onPressed: () => {
                                service.auth.signOut(),
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst),
                                Navigator.pushReplacement(context, route)
                              },
                          child: const Text('Yes'))
                    ]));
      });

  Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
      title: 'Report A Bug',
      subtitle: '',
      leading: const Icon(Icons.bug_report, color: Colors.teal),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Clicked Report A Bug")));
      });

  Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
      title: 'Send Feedback',
      subtitle: '',
      leading: const Icon(Icons.thumb_up, color: Colors.purple),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Clicked SendFeedback")));
      });

  Widget buildDarkMode() => SwitchSettingsTile(
        settingKey: SettingsPage.keyDarkMode,
        leading: const Icon(
          Icons.dark_mode,
          color: Color(0xFF642ef3),
        ),
        title: 'Dark Mode',
        onChange: (_) {},
      );
}
