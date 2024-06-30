import 'package:clean_flutter_app/domain/entities/entities.dart';
import 'package:clean_flutter_app/domain/usecases/usecases.dart';
import 'package:clean_flutter_app/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  final RxString _navigateTo = RxString('');

  GetxSplashPresenter({required this.loadCurrentAccount});

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount() async {
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value = account == null ? '/login' : '/surveys';
    } catch (error) {
      _navigateTo.value = '/login';
    }
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late String token;
  late LoadCurrentAccountSpy loadCurrentAccount;
  late GetxSplashPresenter sut;

  When mockLoadCurrentAccount() {
    return when(() => loadCurrentAccount.load());
  }

  setUp(() {
    token = faker.guid.guid();
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);

    mockLoadCurrentAccount().thenAnswer((_) async => AccountEntity(token));
  });

  test('should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('should go to surveys page on success', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));  
  
    await sut.checkAccount();
  });

  test('should go to login page when account is null', () async {
    mockLoadCurrentAccount().thenAnswer((_) async => null);
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));  
  
    await sut.checkAccount();
  });

  test('should go to login page on error', () async {
    mockLoadCurrentAccount().thenThrow(Exception());
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));  
  
    await sut.checkAccount();
  });
}
