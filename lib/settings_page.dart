// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatefulWidget {
  static const keyDarkMode = 'key-dark-mode';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
        ),
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
                  buildDeleteAccount(),
                ],
            ),
            const SizedBox(height: 32),
            SettingsGroup(
                title: 'FEEDBACK',
                children: <Widget> [
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Clicked Logout")
        )
      );
    }
  );

  Widget buildDeleteAccount() => SimpleSettingsTile(
    title: 'Delete Account',
    subtitle: '',
    leading: const Icon(Icons.delete, color: Colors.pink),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Clicked Delete Account")
          )
        );
      }
  );

  Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
      title: 'Report A Bug',
      subtitle: '',
      leading: const Icon(Icons.bug_report, color: Colors.teal),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Clicked Report A Bug")
          )
        );
      }
  );

  Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
      title: 'Send Feedback',
      subtitle: '',
      leading: const Icon(Icons.thumb_up, color: Colors.purple),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Clicked SendFeedback")
          )
        );
      }
  );

 Widget buildDarkMode() => SwitchSettingsTile(
    settingKey: SettingsPage.keyDarkMode,
    leading: const Icon(
      Icons.dark_mode,
      color: Color(0xFF642ef3),
    ),
    title: 'Dark Mode',
    onChange:(_) {},
 );

}
