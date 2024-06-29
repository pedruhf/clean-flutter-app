import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_app/domain/helpers/helpers.dart';
import 'package:clean_flutter_app/data/cache/cache.dart';
import 'package:clean_flutter_app/data/usecases/load_current_account/load_current_account.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  late String token;
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadcurrentAccount sut;

  When mockFetchSecure() {
    return when(() => fetchSecureCacheStorage.fetchSecure(any()));
  }

  void mockFetchSecureSuccess() {
    return mockFetchSecure().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    return mockFetchSecure().thenThrow(Exception());
  }

  setUp(() {
    token = faker.guid.guid();
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadcurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);

    mockFetchSecureSuccess();
  });

  test('should call FetchSecureCacheStorage with corret value', () async {
    await sut.load();

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test('should throw UnexpectedError if FetchSecureCacheStorage throws', () async {
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}