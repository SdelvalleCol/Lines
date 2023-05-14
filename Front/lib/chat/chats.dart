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

  //Datos usuario
  late Uint8List imagen;
  String numero = "";
  String nombre = "";
  String correo = "";
  String tipo = "";

  Future<void> Obtener_datos() async {
    String token = await secureStorage.obtener();
    if (token != null && token != "") {
      var url = Uri.parse(
          '${configuraciones().ip}/usuarios/datos/personales/${token}');
      var respuesta = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      var responseBody = json.decode(respuesta.body);
      setState(() {
        imagen = convertidor().convertToUint8List(responseBody[0]["imagen"]);
        numero = responseBody[0]["numero_telefono"];
        nombre = responseBody[0]["nombre"];
        correo = responseBody[0]["correo"];
        tipo = responseBody[0]["descripcion"];
        load = true;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<List<dynamic>> obtener_chats() async {
    String token = await secureStorage.obtener();
    if (token != null && token != "") {
      var url = Uri.parse('${configuraciones().ip}/usuarios/chat/${token}');
      var respuesta = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      var responseBody = json.decode(respuesta.body);
      return responseBody;
    } else {
      Navigator.pop(context);
      List <dynamic> p = [];
      return  p;

      
    }
  }

  Future<void> pintar_chats() async{
    List <dynamic> p = await obtener_chats();
    List<Widget> chats_aux = [];
    convertidor con = convertidor();
    for(var i = 0 ; i < p.length ; i++){
      imagen = con.convertToUint8List(p[i]["imagen"]);
      Widget q = WidgetChat(logo: imagen, mensaje: "xd");
      chats_aux.add(q);
    }
    setState(() {
      this.chats = chats_aux;
    });
  }

  @override
  void initState() {
    Obtener_datos();
    pintar_chats();
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
                    'Bienvenido ${nombre}',
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
              child: Column(
            children: [
              load ? Image.memory(imagen,width: 300,height: 300,) : CircularProgressIndicator(),
              Text(numero),
              Text(correo),
              Text(nombre),
              Text(tipo)
            ],
          )),
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
