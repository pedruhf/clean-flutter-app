import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_flutter_app/domain/usecases/usecases.dart';

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
    Map<String, dynamic> body,
  });
}

class HttpClientSpy extends Mock implements HttpClient {}

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({ required this.httpClient, required this.url });

  Future<void>? auth(AuthenticationParams params) async {
    final body = {
      'email': params.email,
      'password': params.password,
    };
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

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