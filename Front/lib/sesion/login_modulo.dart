import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lines/sesion/registro_modulo.dart';
import '../chat/chats.dart';
import '../configuraciones/configuraciones.dart';
import 'package:http/http.dart' as http;

class login_modulo extends StatelessWidget {
  login_modulo({super.key});
  TextEditingController _controlador_telefono = TextEditingController();
  TextEditingController _controlador_password = TextEditingController();

  Future<void> ingresar() async {
    var url = Uri.parse('${configuraciones().ip}/usuarios/ingresar');
    var data = {
      "telefono": _controlador_telefono.text,
      "contra": _controlador_password.text,
    };
    var cuerpo = json.encode(data);
    var respuesta = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: cuerpo,
    );
    if (respuesta.statusCode == 200) {
      var responseBody = json.decode(respuesta.body);
      print(responseBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 180,
              height: 125,
            ),
            Container(
              width: 350,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: TextField(
                    controller: _controlador_telefono,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ingresa tu número de telefono',
                    )),
              ),
            ),
            Container(
              width: 350,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: TextField(
                    controller: _controlador_password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ingresa tu contraseña',
                    )),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 175,
              child: ElevatedButton(
                  onPressed: () async {
                    await ingresar();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  child: Text("Ingresar")),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => registro_modulo()));
                },
                child: Text(
                  'Aún no te has registrado? Hazlo aquí',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
