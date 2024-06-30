import 'package:clean_flutter_app/domain/usecases/usecases.dart';
import 'package:clean_flutter_app/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  final RxString _navigateTo = RxString('');

  GetxSplashPresenter({ required this.loadCurrentAccount });

  @override
  Stream<String> get navigateToStream => _navigateTo.stream; 

  @override
  Future<void> checkAccount() async {
    await loadCurrentAccount.load();
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccountSpy loadCurrentAccount;
  late GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    when(() => loadCurrentAccount.load()).thenAnswer((_) async => null);
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  test('should call LoadCurrentAccount', () async {
    

    await sut.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });
}