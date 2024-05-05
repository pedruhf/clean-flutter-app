import 'dart:convert';

import 'package:clean_flutter_app/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {
  When mockPostCall() => when(() => this.post(any(), body: any(named: 'body'), headers: any(named: 'headers')));
  void mockPost(int statusCode, { String body = '{"any_key":"any_value"}' }) => mockPostCall().thenAnswer((_) async => Response(body, statusCode));
}

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(Uri.parse(url), headers: headers, body: jsonBody);
    return jsonDecode(response.body);
  }
}

void main() {
  late ClientSpy client;
  late String url;
  late HttpAdapter sut;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  group('post', () {
    setUp(() {
      client.mockPost(200);
    });

    test('should call post with correct values', () async {
      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(() => client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: '{"any_key":"any_value"}'
      ));
    });

    test('should call post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(() => client.post(
        any(),
        headers: any(named: 'headers'),
      ));
    });

    test('should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {"any_key": "any_value"});
    });
  });
}