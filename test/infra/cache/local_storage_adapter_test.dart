import 'package:clean_flutter_app/infra/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late LocalStorageAdapter sut;
  late String key;
  late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.lorem.word();
  });

  group('saveSecure', () {
    When mockSecureStorage() {
      return when(() => secureStorage.write(
          key: any(named: 'key'), value: any(named: 'value')));
    }

    test('should call secure storage with correct values', () async {
      mockSecureStorage().thenAnswer((invocation) => Future.value());

      await sut.saveSecure(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value)).called(1);
    });

    test('should throw if secure storage throws', () async {
      mockSecureStorage().thenThrow(Exception());

      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    When mockSecureStorage() {
      return when(() => secureStorage.read(key: any(named: 'key')));
    }

    test('should call fetch secure with correct values', () async {
      mockSecureStorage().thenAnswer((invocation) => Future.value(null));

      await sut.fetchSecure(key);

      verify(() => secureStorage.read(key: key)).called(1);
    });
  });
}
