import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lines/configuraciones/alertas.dart';
import 'package:lines/sesion/registro_modulo.dart';
import '../chat/chats.dart';
import '../configuraciones/almacenamieto.dart';
import '../configuraciones/configuraciones.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class login_modulo extends StatefulWidget {
  const login_modulo({super.key});

  @override
  State<login_modulo> createState() => _login_moduloState();
}

class _login_moduloState extends State<login_modulo> {
  TextEditingController _controlador_telefono = TextEditingController();
  TextEditingController _controlador_password = TextEditingController();
  final secureStorage = SecureStorage();

  Future<void> verificar(cadena) async {
    if (cadena != "" && cadena != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => inicio_chats()));
    }
  }

  Future<String> obtenerToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    return token.toString();
  }

  Future<void> ingresar(BuildContext context) async {
    _controlador_telefono.text = "3108805778";
    _controlador_password.text = "hola";
    if (_controlador_password.text != "" && _controlador_password.text != "") {
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
      if (respuesta.statusCode != 404) {
        var responseBody = json.decode(respuesta.body);
        if (respuesta.statusCode == 200) {
          //Actualizar el Token
          var token_ss = await obtenerToken();
          var url2 =
              Uri.parse('${configuraciones().ip}/usuario/registro/token');
          var data2 = {"numero": _controlador_telefono.text, "token": token_ss};
          var cuerpo2 = json.encode(data2);
          var respuesta2 = await http.post(
            url2,
            headers: {
              'Content-Type': 'application/json',
            },
            body: cuerpo2,
          );
          if (respuesta2.statusCode == 200) {
            await secureStorage.registrar(responseBody);
            _controlador_telefono.text = "";
            _controlador_password.text = "";
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => inicio_chats()));
          } else {
            alerta.show(context, "Algo ha salido mal");
          }
        } else {
          alerta.show(context, responseBody["descripcion"]);
        }
      } else {
        alerta.show(context, "Error en el servidor");
      }
    } else {
      alerta.show(context, "Rellene los datos");
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerToken();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      String valor = await secureStorage.obtener();
      verificar(valor);
    });
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
                    await ingresar(context);
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
