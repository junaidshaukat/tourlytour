import '/core/app_export.dart';

class HiveBox {
  static late Box users;

  static Future<bool> onReady() async {
    try {
      users = await Hive.openBox('Users');
      return true;
    } catch (error) {
      console.log(error, "Error::HiveBox::onReady");
      return false;
    }
  }

  static Future onReload() async {
    try {
      await onReady();
      return true;
    } catch (error) {
      console.log(error, "Error::HiveBox::onReload");
      return false;
    }
  }
}
