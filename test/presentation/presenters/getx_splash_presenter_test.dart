import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter_app/domain/entities/entities.dart';
import 'package:clean_flutter_app/domain/usecases/usecases.dart';
import 'package:clean_flutter_app/presentation/presenters/presenters.dart';

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
    await sut.checkAccount(durationInSeconds: 0);

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('should go to surveys page on success', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));  
  
    await sut.checkAccount(durationInSeconds: 0);
  });

  test('should go to login page when account is null', () async {
    mockLoadCurrentAccount().thenAnswer((_) async => null);
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));  
  
    await sut.checkAccount(durationInSeconds: 0);
  });

  test('should go to login page on error', () async {
    mockLoadCurrentAccount().thenThrow(Exception());
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));  
  
    await sut.checkAccount(durationInSeconds: 0);
  });
}
