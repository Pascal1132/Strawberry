import 'package:strawberry/core/models/User.dart';

class SettingsManager {
  String _language = 'en';
  String _theme = 'light';
  User? _user;

  String get language => _language;
  String get theme => _theme;
  User? get user => _user;

  void setLanguage(String language) {
    _language = language;
  }

  void setTheme(String theme) {
    _theme = theme;
  }

  void setUser(User user) {
    _user = user;
  }
}
