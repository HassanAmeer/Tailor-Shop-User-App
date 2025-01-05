import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static const String firstTimeKey = 'firstTimeKey';

  Future<void> setConfig({bool isVFirstTime = true}) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString(firstTimeKey, isVFirstTime.toString());
    });
  }

  Future<ConfigModel?> getConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getString(firstTimeKey).toString();

    return ConfigModel(firstTime: isFirstTime == "true" ? true : false);
  }

  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
/////

class ConfigModel {
  bool firstTime;

  ConfigModel({
    this.firstTime = false,
  });
}
