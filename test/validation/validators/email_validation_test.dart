import 'package:test/test.dart';

import 'package:clean_flutter_app/validation/validators/validators.dart';

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

  test('should return error if email is invalid', () {
    final error = sut.validate('any.email_123!gmail.com');

    expect(error, 'campo inválido');
  });
}