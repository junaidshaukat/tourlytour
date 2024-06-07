import '/core/app_export.dart';

class Launcher {
  /// Method to launch a general URL
  /// @param uri "https://www.example.com"
  static Future<void> https(uri) async {
    Uri url = Uri.parse(uri);
    canLaunchUrl(url).then((value) async {
      await launchUrl(url);
    }, onError: (err) {
      throw Exception('${"could_not_launch".tr} $url');
    });
  }

  static Future<void> mailto(String mail) async {
    Uri url = Uri(scheme: 'mailto', path: mail);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('${"could_not_launch".tr} $url');
    }
  }

  static Future<void> tel(String phone) async {
    Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('${"could_not_launch".tr} $url');
    }
  }

  static Future<void> sms(String phone) async {
    Uri url = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('${"could_not_launch".tr} $url');
    }
  }
}
