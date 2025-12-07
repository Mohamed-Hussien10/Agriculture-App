import 'package:easy_localization/easy_localization.dart';

class Validations {
  Validations._();

  // Validate required text fields
  static String? validateRequiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'required'.tr();
    }
    return null;
  }

  // Validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone Number_required'.tr();
    }
    final RegExp phoneExp = RegExp(r'^\+?\d{8}$');
    if (!phoneExp.hasMatch(value)) {
      return 'invalid_phone_number'.tr();
    }
    return null;
  }

  // Validate ID-NNI
  static String? validateIdNni(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID-NNI_required'.tr();
    }
    final RegExp idExp = RegExp(r'^\d{10}$');
    if (!idExp.hasMatch(value)) {
      return 'invalid_id_nni'.tr();
    }
    return null;
  }

  // Validate dropdown selections
  static String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'required'.tr();
    }
    return null;
  }

  // Validate date
  static String? validateDate(DateTime? date, String fieldName) {
    if (date == null) {
      return 'required'.tr();
    }
    return null;
  }

  // Validate gender selection
  static String? validateGender(int? gender, String fieldName) {
    if (gender == null) {
      return 'required'.tr();
    }
    return null;
  }

  // Validate group number
  static String? validateGroupNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Not required
    }
    final RegExp numberExp = RegExp(r'^\d+$');
    if (!numberExp.hasMatch(value)) {
      return 'invalid_group_number'.tr();
    }
    return null;
  }

  // Validate N GIE
  static String? validateNGie(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Not required
    }
    final RegExp numberExp = RegExp(r'^\d+$');
    if (!numberExp.hasMatch(value)) {
      return 'invalid_n_gie'.tr();
    }
    return null;
  }

  // Validate URL
  static String? validateUrl(String? url) {
    if (url == null || url.isEmpty) {
      return null; // Not required
    }
    final urlPattern = RegExp(
      r'^(https?:\/\/)?' // http:// or https://
      r'([\da-z\.-]+)\.([a-z\.]{2,6})' // domain
      r'([\/\w \.-]*)*\/?$', // path
    );
    if (!urlPattern.hasMatch(url)) {
      return 'invalid_url'.tr();
    }
    return null;
  }

  // Validate course name
  static String? validateCourseName(String? value) {
    if (value == null || value.isEmpty) {
      return 'course_name_required'.tr();
    }
    if (value.length < 3) {
      return 'invalid_course_name'.tr();
    }
    return null;
  }
}
