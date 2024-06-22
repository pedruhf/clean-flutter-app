import 'package:clean_flutter_app/main/builders/validation_builder.dart';

import '../../../../presentation/protocols/validation.dart';
import '../../../../validation/validators/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(getLoginValidations());
}

List<FieldValidation> getLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().build(),
  ];
}