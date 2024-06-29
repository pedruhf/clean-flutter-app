import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_app/domain/usecases/load_current_account.dart';

class LocalLoadcurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadcurrentAccount({ required this.fetchSecureCacheStorage });

  @override
  Future<AccountEntity> load() async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    return AccountEntity(token);
  }
}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}


void main() {
  late String token;
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadcurrentAccount sut;

  setUp(() {
    token = faker.guid.guid();
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadcurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
  });

  When mockFetchSecureCacheStorage() {
    return when(() => fetchSecureCacheStorage.fetchSecure(any()));
  }

  test('should call FetchSecureCacheStorage with corret value', () async {
    mockFetchSecureCacheStorage().thenAnswer((_) async => token);

    await sut.load();

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('should return an AccountEntity', () async {
    mockFetchSecureCacheStorage().thenAnswer((_) async => token);

    final account = await sut.load();

    expect(account, AccountEntity(token));
  });
}