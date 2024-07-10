import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import './protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  @override
  List<Object?> get props => [field];

  const EmailValidation(this.field);

  @override
  ValidationError? validate(String value) {
    final regex = RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$");
    final isValid = value.isEmpty || regex.hasMatch(value);
    return isValid ? null : ValidationError.invalidField;
  }
}
