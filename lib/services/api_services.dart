import 'package:flutter_task/services/api_keys.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const Duration apiTimeOut = Duration(minutes: 2);

  /// to send get api request
  Future<http.Response> getRequest({
    Uri? uri,
    Map<String, String>? headers,
  }) async {
    return await http
        .get(uri ?? Uri.parse(ApiEndPoints.apiEndPoint), headers: headers)
        .timeout(apiTimeOut);
  }
}
