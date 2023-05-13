import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class convertidor {
  Future<String> convbase64(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    String base64Image = base64Encode(fileBytes);
    return base64Image;
  }

  Uint8List convertToUint8List(String base64Image) {
    List<int> bytes = base64Decode(base64Image);
    return Uint8List.fromList(bytes);
  }
}
