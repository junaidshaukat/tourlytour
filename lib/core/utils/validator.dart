import '/core/app_export.dart';

class Validator {
  static String? username(String? input, {bool isRequired = true}) {
    const pattern = r'^[A-Za-z0-9_-\s+]{3,50}$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_your_name".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_username_format".tr;
    } else {
      return null;
    }
  }

  static String? email(String? input, {bool isRequired = true}) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_your_email".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_email_format".tr;
    } else {
      return null;
    }
  }

  static String? password(String? input, {bool isRequired = true}) {
    const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?\d)(?=.*?[^\w\s]).{8,}$';
    RegExp regExp = RegExp(pattern);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_your_password".tr;
    } else if (!regExp.hasMatch(input)) {
      return "password_must_contain_the_following".tr;
    } else {
      return null;
    }
  }

  static String? confirmPassword(String? input, String text,
      {bool isRequired = true}) {
    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_re_enter_your_password_for_confirmation".tr;
    } else if (input != text) {
      return "passwords_do_not_match".tr;
    } else {
      return null;
    }
  }

  static String? otp(String? input, {bool isRequired = true}) {
    const pattern = r'^\d{6}$';
    RegExp regExp = RegExp(pattern);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_the_code_sent_to_your_email".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_otp_format".tr;
    } else {
      return null;
    }
  }

  static String? phone(String? input, {bool isRequired = true}) {
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regExp = RegExp(pattern);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_your_phone".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_phone_format".tr;
    } else {
      return null;
    }
  }

  static String? fullName(String? input, {bool isRequired = true}) {
    const pattern = r'^[A-Za-z0-9_-\s+]{3,50}$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_your_full_name".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_full_name_format".tr;
    } else {
      return null;
    }
  }

  static String? emailAddress(String? input, {bool isRequired = true}) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_your_email_address".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_email_address_format".tr;
    } else {
      return null;
    }
  }

  static String? mobileNumber(String? input, {bool isRequired = true}) {
    const pattern = r'^(\+\d{1,3}[- ]?)?\d{8,15}$';
    RegExp regExp = RegExp(pattern);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_your_mobile_number".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_mobile_number_format".tr;
    } else {
      return null;
    }
  }

  static String? hotelName(String? input, {bool isRequired = true}) {
    const pattern = r'^[A-Za-z0-9_-\s+]{3,50}$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_the_hotel_name".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_hotel_name_format".tr;
    } else {
      return null;
    }
  }

  static String? hotelAddress(String? input, {bool isRequired = true}) {
    const pattern = r'^[A-Za-z0-9_-\s+]{3,50}$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_the_hotel_address".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_hotel_address_format".tr;
    } else {
      return null;
    }
  }

  static String? hotelRoomNumber(String? input, {bool isRequired = true}) {
    const pattern = r'^[A-Za-z0-9_-\s+]{3,50}$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_the_hotel_room_number".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_hotel_room_number_format".tr;
    } else {
      return null;
    }
  }

  static String? name(String? input, {bool isRequired = true}) {
    const pattern = r'^[A-Za-z0-9_-\s+]{3,50}$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_the_guest_name".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_guest_name_format".tr;
    } else {
      return null;
    }
  }

  static String? passport(String? input, {bool isRequired = true}) {
    const pattern = r'^[A-Za-z0-9_-\s+]{3,50}$';
    RegExp regExp = RegExp(pattern, caseSensitive: false);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_the_guest_passport".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_guest_passport_format".tr;
    } else {
      return null;
    }
  }

  static String? dateOfBirth(String? input, {bool isRequired = true}) {
    const pattern =
        r'^(\d{4}-\d{2}-\d{2})|(\d{2}/\d{2}/\d{4})|(\d{2}-\d{2}-\d{4})$';
    RegExp regExp = RegExp(pattern);

    if (input != null && !isRequired && input.isNotEmpty) {
      isRequired = true;
    }

    if (!isRequired) {
      return null;
    } else if (input == null || input.isEmpty) {
      return "please_enter_the_guest_date_of_birth".tr;
    } else if (!regExp.hasMatch(input)) {
      return "invalid_guest_date_of_birth_format".tr;
    } else {
      if (!_isValidDate(input)) {
        return "invalid_guest_date_of_birth_format".tr;
      }
      return null;
    }
  }

  static bool _isValidDate(String date) {
    List<String> formats = ['yyyy-MM-dd', 'dd/MM/yyyy', 'MM-dd-yyyy'];
    for (var format in formats) {
      try {
        DateFormat dateFormat = DateFormat(format);
        dateFormat.parseStrict(date);
        return true;
      } catch (e) {
        // Ignore and try the next format
      }
    }
    return false;
  }
}
