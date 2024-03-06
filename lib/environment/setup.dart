import 'package:dialup_mobile_app/environment/index.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String dev = 'dev';
  static const String sit = 'sit';
  static const String uat = 'uat';
  static const String prod = 'prod';

  late BaseConfig config;

  initConfig(String environment) {
    config = getConfig(environment);
  }

  BaseConfig getConfig(String environment) {
    switch (environment) {
      case Environment.dev:
        return EnvConfig();
      case Environment.sit:
        return EnvConfig();
      case Environment.uat:
        return EnvConfig();
      case Environment.prod:
        return EnvConfig();
      default:
        return EnvConfig();
    }
  }

  static String getName(String environment) {
    switch (environment) {
      case Environment.prod:
        return '.env.production';
      case Environment.uat:
        return '.env.uat';
      case Environment.sit:
        return '.env.sit';
      case Environment.dev:
        return '.env.development';
      default:
        return '.env.development';
    }
  }
}
