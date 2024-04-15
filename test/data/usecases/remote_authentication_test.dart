import 'package:clean_flutter_app/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_flutter_app/data/http/http.dart';
import 'package:clean_flutter_app/data/usecases/usecases.dart';
import 'package:clean_flutter_app/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication sut;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
  });

  test('should call HttpClient with correct input', () async {
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenAnswer((_) async =>
        {"accessToken": faker.guid.guid(), 'name': faker.person.name()});

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

  test('should throw unexpected error if HttpClient returns 400', () async {
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw unexpected error if HttpClient returns 404', () async {
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenThrow(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw unexpected error if HttpClient returns 500', () async {
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenThrow(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw invalid credentials error if HttpClient returns 401',
      () async {
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenThrow(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('should throw an Account if HttpClient returns 200', () async {
    final accessToken = faker.guid.guid();
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenAnswer(
        (_) async => {'accessToken': accessToken, 'name': faker.person.name()});

    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });

  test(
      'should throw unexpected error if HttpClient returns 200 with invalid data',
      () async {
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    )).thenAnswer((_) async => {'invalidKey': 'invalidValue'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
