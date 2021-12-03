import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class HeaderPage extends StatelessWidget {
  static const keyDarkMode = 'key-dark-mode';

  @override
  Widget build(BuildContext context) => Column(
    children: [
      buildHeader(),
      const SizedBox(height; 32),
      buildUser(context),
      buildDarkMode,
    ],
  ); // Column
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext> context) => Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            SettingsGroup(
                title: 'GENERAL',
                children: <Widget>[
                  buildLogout(),
                  buildDeleteAccount(),
                ], // <Widget>[]
            ), // SettingsGroup
            const SizedBox(height: 32),
            SettingsGroup(
                title: 'FEEDBACK',
                children <Widget> [
                  const SizedBox(height: 8),
                  buildReportBug(context),
                  buildSendFeedback(context),
                ], // <Widget>
                ), // SettingsGroup
          ],
        ), // ListView
      ), // SafeArea
  ); // Scaffold

  Widget buildLogout() => SimpleSettingsTile(
    title: 'Logout',
    subtitle: '',
    leading: Icon(icon: Icons.logout, color: Colors.blueAccent),
    onTap: () => Utils.showSnackBar(context, "Clicked Logout"))
  ); // SimpleSettingsTile

  Widget buildDeleteAccount() => SimpleSettingsTile(
    title: 'Delete Account',
    subtitle: '',
    leading: Icon(icon: Icons,delete, color: Colors.pink),
    onTap: () => Utils.showSnackBar(context, 'Clicked Delete Account'),
  ); // SimpleSettingTile

  Widget BuildReportBug(BuildContext context) => SimpleSettingsTile(
      title: 'Report A Bug',
      subtitle: '',
      leading: Icon(icon: Icons.bug_report, color: Colors.teal)
      onTap: () => Utils.showSnackBar(context, 'Clicked Report A Bug')
  ), // SimpleSettingsTile

  Widget BuildSendFeedback(BuildContext context) => SimpleSettingsTile(
      title: 'Send Feedback',
      subtitle: '',
      leading: Icon(icon: Icons.thumb_up, color: Colors.purple)
      onTap: () => Utils.showSnackBar(context, 'Clicked SendFeedback')
  ), // SimpleSettingsTile

 Widget buildDarkMode() => SwitchSettingsTile(
   settingsKey: keyDarkMode,
   leading: Icon(
     icon: Icons.dark_mode,
     color: Color(0xFF642ef3),
   ), // IconWidget
   title: 'Dark Mode',
   onChange:(_) {},
 ); // SwitchSettingsTile

}
