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
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, null);
  });

  test('should return null if email is valid', () {
    final error = sut.validate('any.email_123@gmail.com');

    expect(error, null);
  });
}