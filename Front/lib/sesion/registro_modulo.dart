import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class registro_modulo extends StatefulWidget {
  const registro_modulo({super.key});

  @override
  State<registro_modulo> createState() => _registro_moduloState();
}

class _registro_moduloState extends State<registro_modulo> {
  String? imagenbase;
  bool ocultar = true;
  TextEditingController numero_telefono = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController contrasena = TextEditingController();

  Future<String> convbase64(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    String base64Image = base64Encode(fileBytes);
    return base64Image;
  }

  Future<void> obtener_imagen() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File? imagen = File(pickedImage.path);
      String subb4 = await convbase64(imagen!);
      setState(() {
        imagenbase = subb4;
      });
    } else {
      setState(() {
        imagenbase = "";
      });
    }
  }

  Future<void> registrar_usuario() async {
    print(numero_telefono.text);
    print(nombre.text);
    print(correo.text);
    print(contrasena.text);
    print(imagenbase);
    if (numero_telefono.text != "" &&
        nombre.text != "" &&
        correo.text != "" &&
        contrasena.text != "" &&
        (imagenbase != "" && imagenbase != null)) {
      var url = Uri.parse('localhost:5000/usuarios/registrar');
      var data = {
        "numero": numero_telefono,
        "nombre": nombre.text,
        "correo": correo.text,
        "contrasena": contrasena.text,
        "cargo": 0
      };
    } else {
      print("No se logro");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                  controller: numero_telefono,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingresa tu número de telefono',
                  )),
              TextField(
                  controller: nombre,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingresa tu nombre',
                  )),
              TextField(
                  controller: correo,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingresa tu correo',
                  )),
              TextField(
                  controller: contrasena,
                  obscureText: ocultar,
                  decoration: InputDecoration(
                      labelText: 'Contraseña',
                      suffixIcon: IconButton(
                        icon: Icon(
                            ocultar ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            ocultar = !ocultar;
                          });
                        },
                      ))),
              ElevatedButton(
                onPressed: () async => obtener_imagen(),
                child: Text('Seleccionar imagen'),
              ),
              ElevatedButton(
                onPressed: () async => registrar_usuario(),
                child: Text('Registrarse'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
