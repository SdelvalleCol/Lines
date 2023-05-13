import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lines/configuraciones/configuraciones.dart';
import 'package:lines/configuraciones/convertidor.dart';

class registro_modulo extends StatefulWidget {
  const registro_modulo({super.key});

  @override
  State<registro_modulo> createState() => _registro_moduloState();
}

class _registro_moduloState extends State<registro_modulo> {
  //Base64
  String? imagenbase;
  //Contraseñas (Ocultar)
  bool ocultar = true;

  //Menu desplegable
  String? _selectedItem;
  List<String> _items = ['Policia', 'Administrativo', 'Gerente', 'Otros'];

  //Controladores de texto
  TextEditingController numero_telefono = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController contrasena = TextEditingController();

  Future<void> obtener_imagen() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File? imagen = File(pickedImage.path);
      String subb4 = await convertidor().convbase64(imagen!);
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
    if (numero_telefono.text != "" &&
        nombre.text != "" &&
        correo.text != "" &&
        contrasena.text != "" &&
        (imagenbase != "" && imagenbase != null) &&
        (_selectedItem != null && _selectedItem != "")) {
      int indice = _items.indexOf(_selectedItem.toString());
      print(indice);
      var url = Uri.parse('${configuraciones().ip}/usuarios/registrar');
      var data = {
        "numero": numero_telefono.text,
        "nombre": nombre.text,
        "correo": correo.text,
        "contrasena": contrasena.text,
        "imagen": imagenbase,
        "cargo": indice
      };
      print(data);
      var cuerpo = json.encode(data);
      var respuesta = await http.post(
        url,
        headers: {
          'Content-Type':
              'application/json', 
        },
        body: cuerpo,
      );
    print(respuesta);
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
              DropdownButton<String>(
                value: _selectedItem,
                hint: Text('¿Qué tipo de persona es?'),
                items: _items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                },
              ),
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
