import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String? validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;
  
  RequiredFieldValidation(this.field);

  @override
  String? validate(String value) {
    return value.isEmpty ? 'campo obrigatório' : null;
  }
}

void main() {
  test('should return null if value is not empty', () {
    final sut = RequiredFieldValidation('any_field');

    final error = sut.validate('any_value');

    expect(error, null);
  });

  test('should return error message if value is empty', () {
    final sut = RequiredFieldValidation('any_field');

    final error = sut.validate('');

    expect(error, 'campo obrigatório');
  });
}