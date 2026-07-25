import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('app');
  }

  static Box get box => Hive.box('app');
}
