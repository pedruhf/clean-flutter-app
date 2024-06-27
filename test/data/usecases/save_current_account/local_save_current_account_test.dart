import 'package:clean_flutter_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_app/domain/helpers/helpers.dart';
import 'package:clean_flutter_app/domain/usecases/save_current_account.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(
          key: 'token', value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({required String key, required String value});
}

class SaveSecureCacheStorageSpy extends Mock
    implements SaveSecureCacheStorage {}

void main() {
  late SaveSecureCacheStorageSpy cacheStorage;
  late String token;
  late AccountEntity account;
  late LocalSaveCurrentAccount sut;

  setUp(() {
    cacheStorage = SaveSecureCacheStorageSpy();
    token = faker.guid.guid();
    account = AccountEntity(token);
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: cacheStorage);
  });

  When mockSaveSecureCacheStorage() {
    return when(() => cacheStorage.saveSecure(
        key: any(named: 'key'), value: any(named: 'value')));
  }

  test('should call SaveSecureCacheStorage with correct values', () async {
    mockSaveSecureCacheStorage().thenAnswer((invocation) => Future.value());

    await sut.save(account);

    verify(() => cacheStorage.saveSecure(key: 'token', value: token)).called(1);
  });

  test('should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    mockSaveSecureCacheStorage().thenThrow(Exception());

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
