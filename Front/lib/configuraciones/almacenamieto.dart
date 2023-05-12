import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = FlutterSecureStorage();

  Future<void> registrar(String token) async {
    await storage.write(key: 'key', value: token);
  }

  Future<String> obtener() async {
    String? valor = await storage.read(key: 'key');
    if (valor == "" || valor == null) {
      return "";
    } else {
      return valor.toString();
    }
  }

  Future<void> eliminar() async {
    await storage.delete(key: 'key');
  }
}
