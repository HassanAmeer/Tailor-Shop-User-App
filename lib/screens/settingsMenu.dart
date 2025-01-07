import 'package:flutter/material.dart';
import 'package:tailor_admin/screens/settings.dart';

import 'intro.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: ListView(children: [
          ListTile(
              title: Text('App Settings'),
              subtitle: Text('Manage your app preferences and configurations.'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingPage()));
              }),
          Divider(),
          ListTile(
              title: Text('Introduction'),
              subtitle: Text('Manage Intro Screens'),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateIntroSections()));
              }),
          Divider()
        ]));
  }
}
