import 'package:test/test.dart';

import 'package:clean_flutter_app/validation/validators/validators.dart';
import 'package:clean_flutter_app/presentation/protocols/protocols.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = const RequiredFieldValidation('any_field');
  });

  test('should return null if value is not empty', () {
    final error = sut.validate('any_value');

    expect(error, null);
  });

  test('should return error message if value is empty', () {
    final error = sut.validate('');

    expect(error, ValidationError.requiredField);
  });
}