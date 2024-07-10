import './protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError? validate({required String field, required String value}) {
    final filteredValidations = validations.where((validation) => validation.field == field);
    for (final validation in filteredValidations) {
      final error = validation.validate(value);
      if (error != null) return error;
    }
    return null;
  }
}
