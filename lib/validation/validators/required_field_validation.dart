import 'package:clean_flutter_app/presentation/protocols/validation.dart';
import 'package:equatable/equatable.dart';

import 'protocols/field_validation.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  
  @override
  List<Object?> get props => [field];

  const RequiredFieldValidation(this.field);

  @override
  ValidationError? validate(String value) {
    return value.isEmpty ? ValidationError.requiredField : null;
  }
}
