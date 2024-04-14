import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_flutter_app/data/http/http.dart';
import 'package:clean_flutter_app/data/usecases/usecases.dart';
import 'package:clean_flutter_app/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}



void main() {
  test('should call HttpClient with correct input', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    final params = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());

    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.password,
      },
    ));
  });
}