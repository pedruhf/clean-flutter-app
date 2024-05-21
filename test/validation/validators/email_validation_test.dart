import 'package:test/test.dart';

import 'package:clean_flutter_app/validation/validators/protocols/field_validation.dart';

class EmailValidation implements FieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String value) {
    return null;
  }
  
}

void main() {
  test('should return null if email is empty', () {
    final sut = EmailValidation('any_field');

    final error = sut.validate('');

    expect(error, null);
  });
}