import 'protocols/field_validation.dart';

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;
  
  RequiredFieldValidation(this.field);

  @override
  String? validate(String value) {
    return value.isEmpty ? 'campo obrigatório' : null;
  }
}
