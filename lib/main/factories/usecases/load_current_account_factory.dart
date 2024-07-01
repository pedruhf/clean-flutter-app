import '../../../domain/usecases/usecases.dart';
import '../../../data/usecases/usecases.dart';
import '../cache/cache.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(fetchSecureCacheStorage: makeLocalStorageAdapter());
}
