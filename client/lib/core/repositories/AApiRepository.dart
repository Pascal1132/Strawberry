import 'package:http/http.dart';

class AApiRepository {
  final String _baseUrl = 'https://localhost:7091/';
  final Client _client = Client();

  Future<Response> get(String path) async {
    final Response response = await _client.get(Uri.parse('$_baseUrl$path'));
    return response;
  }

  Future<Response> post(String path,
      {required Map<String, dynamic> body}) async {
    final Response response =
        await _client.post(Uri.parse('$_baseUrl$path'), body: body);
    return response;
  }

  Future<Response> put(String path,
      {required Map<String, dynamic> body}) async {
    final Response response =
        await _client.put(Uri.parse('$_baseUrl$path'), body: body);
    return response;
  }

  Future<Response> delete(String path) async {
    final Response response = await _client.delete(Uri.parse('$_baseUrl$path'));
    return response;
  }
}
