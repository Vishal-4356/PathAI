import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadService {
  static const String baseUrl = "http://10.111.117.34:8000"; // CHANGE IP

  static Future<Map<String, dynamic>> captureAndAnalyze() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      return {"error": "Camera cancelled"};
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/analyze"),
    );

    // ✅ THESE TWO LINES ARE CRITICAL
    request.fields['lat'] = "11.015";
    request.fields['lon'] = "77.022";

    request.files.add(
      await http.MultipartFile.fromPath('file', image.path),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    return jsonDecode(body);
  }
}
