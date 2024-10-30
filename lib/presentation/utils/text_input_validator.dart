import 'package:ezeness/generated/l10n.dart';

class TextInputValidator {
  final int maxLength;
  final int minLength;
  List<InputValidator> validators;

  TextInputValidator(
      {required this.validators, this.maxLength = 20, this.minLength = 8});

  String? validate(String? input) {
    if (input != null) {
      String trimmedInput = input.trim();
      if (validators.contains(InputValidator.requiredField)) {
        if (trimmedInput.isEmpty) {
          return S.current.requiredField;
        }
      }
      if (validators.contains(InputValidator.email)) {
        if (trimmedInput.isNotEmpty &&
            !RegExp(r'^[A-Z0-9._%+-]+@[A-Z0-9._]+\.[A-Z]{2,4}$',
                    caseSensitive: false)
                .hasMatch(trimmedInput)) {
          return S.current.emailIsNotValid;
        }
      }
      if (validators.contains(InputValidator.minLength)) {
        if (trimmedInput.isNotEmpty && trimmedInput.length < minLength) {
          return S.current.minLengthValidator(minLength);
        }
      }
      if (validators.contains(InputValidator.maxLength)) {
        if (trimmedInput.isNotEmpty && trimmedInput.length > maxLength) {
          return S.current.minLengthValidator(maxLength);
        }
      }
      if (validators.contains(InputValidator.mobile)) {
        if (trimmedInput.isNotEmpty &&
            !RegExp(r'^09[0-9]{8}$').hasMatch(trimmedInput)) {
          return S.current.mobileIsNotValid;
        }
      }
      if (validators.contains(InputValidator.website)) {
        if (trimmedInput.isNotEmpty &&
            !Uri.tryParse(trimmedInput)!.hasAbsolutePath) {
          return S.current.websiteIsNotValid;
        }
      }
      if (validators.contains(InputValidator.userName)) {
        if (trimmedInput.isNotEmpty &&
            !RegExp(r'^(?=[a-zA-Z0-9._]{5,35}$)(?!.*[_.]{2})[^_.].*[^_.]$')
                .hasMatch(trimmedInput)) {
          return S.current.userNameIsNotValid;
        }
      }
      if (validators.contains(InputValidator.hashtags)) {
        if (trimmedInput.isNotEmpty &&
            !RegExp(r'^#[\w\u0600-\u06FF]+(\s*#[\w\u0600-\u06FF]+)*$')
                .hasMatch(trimmedInput)) {
          return S.current.hashtagsMustBeInCorrectForm;
        }
      }
    }

    return null;
  }

  static String? validateDropDown(int? value) {
    if (value == -1) {
      return S.current.requiredField;
    }
    return null;
  }

  static String? validateDropDownString(String? value) {
    if (value == '') {
      return S.current.requiredField;
    }
    return null;
  }
}

enum InputValidator {
  email,
  requiredField,
  minLength,
  maxLength,
  mobile,
  website,
  userName,
  hashtags
}
