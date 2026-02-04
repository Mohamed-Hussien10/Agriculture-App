import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ModelService {
  final String endpoint = "https://hazemgamal223311--yolo-detection-api-predict.modal.run/";

  Future<Map<String, dynamic>> detectObjects(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(endpoint));
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    var respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return json.decode(respStr);
    } else {
      throw Exception('Failed to detect objects: $respStr');
    }
  }
}
