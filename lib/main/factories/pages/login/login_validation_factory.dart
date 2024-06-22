import '../../../../presentation/protocols/validation.dart';
import '../../../../validation/validators/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(getLoginValidations());
}

List<FieldValidation> getLoginValidations() {
  return [
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ];
}