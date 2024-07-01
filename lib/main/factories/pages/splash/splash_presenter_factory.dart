
import '../../factories.dart';
import '../../../../ui/pages/pages.dart';
import '../../../../presentation/presenters/presenters.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(
    loadCurrentAccount: makeLocalLoadCurrentAccount(),
  );
}
