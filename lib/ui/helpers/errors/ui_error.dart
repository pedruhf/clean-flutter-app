import 'package:clean_flutter_app/ui/helpers/i18n/resources.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials
}

extension UIErrorExtension on UIError {
  String get description {
    switch(this) {
      case UIError.requiredField: return R.strings.msgRequiredField;
      case UIError.invalidField: return R.strings.msgInvalidField;
      case UIError.invalidCredentials: return R.strings.msgInvalidCredentials;
      case UIError.unexpected: return R.strings.msgUnexpected;
      default: return '';
    }
  }
}