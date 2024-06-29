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
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadcurrentAccount sut;

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadcurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
  });

  When mockFetchSecureCacheStorage() {
    return when(() => fetchSecureCacheStorage.fetchSecure(any()));
  }

  test('should call FetchSecureCacheStorage with corret value', () async {
    mockFetchSecureCacheStorage().thenAnswer((invocation) => Future.value());

    await sut.load();

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}