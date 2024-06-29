import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LocalLoadcurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadcurrentAccount({ required this.fetchSecureCacheStorage });

  Future<void> load() async {
    fetchSecureCacheStorage.fetchSecure('token');
  }
}

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}


void main() {
  test('should call FetchSecureCacheStorage with corret value', () async {
    final fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    final sut = LocalLoadcurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    when(() => fetchSecureCacheStorage.fetchSecure(any())).thenAnswer((invocation) => Future.value());

    await sut.load();

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}