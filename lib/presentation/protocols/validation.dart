abstract class Validation {
  ValidationError? validate({required String field, required String value});
}

enum ValidationError {
  requiredField,
  invalidField,
}
