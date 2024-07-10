import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_app/validation/validators/protocols/protocols.dart';
import 'package:clean_flutter_app/validation/validators/validators.dart';
import 'package:clean_flutter_app/presentation/protocols/protocols.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;
  late ValidationComposite sut;

  void mockValidation1(ValidationError? error) {
    when(() => validation1.validate(any())).thenReturn(error);
  }

  void mockValidation2(ValidationError? error) {
    when(() => validation2.validate(any())).thenReturn(error);
  }

  void mockValidation3(ValidationError? error) {
    when(() => validation3.validate(any())).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(() => validation1.field).thenReturn('any_field');
    mockValidation1(null);
    validation2 = FieldValidationSpy();
    when(() => validation2.field).thenReturn('other_field');
    mockValidation2(null);
    validation3 = FieldValidationSpy();
    when(() => validation3.field).thenReturn('any_field');
    mockValidation3(null);
    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('should return null if all validations returns null or empty', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });

  test('should return the first error', () {
    mockValidation1(ValidationError.requiredField);
    mockValidation2(ValidationError.invalidField);
    mockValidation3(ValidationError.invalidField);

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, ValidationError.requiredField);
  });

  test('should return the first error of the field', () {
    mockValidation1(ValidationError.invalidField);
    mockValidation2(ValidationError.requiredField);
    mockValidation3(ValidationError.invalidField);

    final error = sut.validate(field: 'other_field', value: 'any_value');

    expect(error, ValidationError.requiredField);
  });
}