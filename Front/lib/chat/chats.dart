import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lines/configuraciones/almacenamieto.dart';
import 'package:http/http.dart' as http;
import 'package:lines/configuraciones/convertidor.dart';
import '../configuraciones/configuraciones.dart';
import 'widgets/chatmodulo.dart';
import 'dart:convert';

class inicio_chats extends StatefulWidget {
  @override
  _inicio_chat createState() => _inicio_chat();
}

class _inicio_chat extends State<inicio_chats> {
  int indice = 0;
  List<Widget> chats = [];

  final secureStorage = SecureStorage();
  bool load = false;
  late Uint8List imagen; 

  Future<void> Obtener_datos() async {
    String token = await secureStorage.obtener();
    if (token != null && token != "") {
      var url = Uri.parse('${configuraciones().ip}/usuarios/datos/personales/${token}');
      var respuesta = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      var responseBody = json.decode(respuesta.body);
      setState(() {
        imagen = convertidor().convertToUint8List(responseBody[0]["imagen"]);
        load = true;
      });
      
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> obtener_chats() async {
    String token = await secureStorage.obtener();
    if (token != null && token != "") {
      var url = Uri.parse('${configuraciones().ip}/usuarios/chat/${token}');
      var respuesta = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      var responseBody = json.decode(respuesta.body);
      print(responseBody);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    Obtener_datos();
    obtener_chats();
    super.initState();
  }

  void navegacion_indice(int index) {
    setState(() {
      indice = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: indice,
        children: [
          // Contenido de la pestaña "Home"
          SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  width: double.infinity,
                  color: Colors.purple,
                  padding: EdgeInsets.only(bottom: 20, left: 10),
                  child: Text(
                    'Bienvenido @Yiyu',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Calibri',
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: chats,
                  ),
                ),
              ],
            ),
          ),
          // Contenido de la pestaña "Profile"
          SafeArea(
            child: load
                ? Image.memory(imagen)
                : CircularProgressIndicator(), 
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              navegacion_indice(0);
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              navegacion_indice(1);
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await secureStorage.eliminar();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
