import '../../../domain/usecases/usecases.dart';
import '../../factories/cache/local_storage_adapter_factory.dart';
import '../../../data/usecases/save_current_account/local_save_current_account.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(saveSecureCacheStorage: makeLocalStorageAdapter());
}
