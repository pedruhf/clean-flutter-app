import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map?> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    if (method != 'post') throw HttpError.serverError;
    final jsonBody = body != null ? jsonEncode(body) : null;
    try {
      final response = await client.post(Uri.parse(url), headers: headers, body: jsonBody);
      return _handleResponse(response);
    } on Exception {
      throw HttpError.serverError;
    }
  }

  Map? _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    }
    else if (response.statusCode == 204) {
      return null;
    }
    else if (response.statusCode == 400) {
      throw HttpError.badRequest; 
    }
    else if (response.statusCode == 401) {
      throw HttpError.unauthorized; 
    }
    else if (response.statusCode == 403) {
      throw HttpError.forbidden; 
    }
    else if (response.statusCode == 404) {
      throw HttpError.notFound; 
    }
    throw HttpError.serverError;
  }
}