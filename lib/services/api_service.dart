import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000"; 

  static Future<List<dynamic>?> getPrediction(List<double> inputData) async {
    final url = Uri.parse('$baseUrl/predict');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"input": inputData}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result["prediction"];
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
