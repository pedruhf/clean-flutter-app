import 'package:clean_flutter_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_app/domain/usecases/save_current_account.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({ required this.saveSecureCacheStorage });

  @override
  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({ required String key, required String value });
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {} 

void main() {
  test('should call SaveCacheStorage with correct values', () async {
    final cacheStorage = SaveSecureCacheStorageSpy();
    final token = faker.guid.guid();
    final account = AccountEntity(token);
    final sut = LocalSaveCurrentAccount(saveSecureCacheStorage: cacheStorage);
    when(() => cacheStorage.saveSecure(key: 'token', value: token)).thenAnswer((invocation) => Future.value());

    await sut.save(account);

    verify(() => cacheStorage.saveSecure(key: 'token', value: token)).called(1);
  });
}