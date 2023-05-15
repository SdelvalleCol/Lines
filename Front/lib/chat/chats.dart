import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lines/configuraciones/alertas.dart';
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
  Uint8List imagen = Uint8List(0);
  String numero = "";
  String nombre = "";
  String correo = "";
  String tipo = "";

  //chats
  TextEditingController _controlador_numero = TextEditingController();

//OBTENER DATOS
//INFORMACION PERSONAL
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
        pintar_chats();
      });
    } else {
      Navigator.pop(context);
    }
  }

//CHATS RELACIONADOS
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
      List<dynamic> p = [];
      return p;
    }
  }

//IMPRIMIR CHATS
  Future<void> pintar_chats() async {
    List<dynamic> p = await obtener_chats();
    List<Widget> chats_aux = [];
    convertidor con = convertidor();
    for (var i = 0; i < p.length; i++) {
      Uint8List imagen_2 = con.convertToUint8List(p[i]["imagen"]);
      Widget q = WidgetChat(
        logo: imagen_2,
        nombre: p[i]["nombre"],
        correo: p[i]["correo"],
        id_chat:p[i]["idchats"],
        numero1: numero,
        numero2: p[i]["numero_telefono"],
      );
      chats_aux.add(q);
    }
    setState(() {
      this.chats = chats_aux;
    });
  }

//REGISTRAR NUEVOS CHATS
  void registro(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20.0,
              right: 20.0,
              top: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Crear nuevo chat',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: _controlador_numero,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Ingrese el número de telefono'),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                    onPressed: () async {
                      if (numero != "" &&
                          numero != null &&
                          _controlador_numero.text != "" &&
                          _controlador_numero.text != null) {
                        var url = Uri.parse(
                            '${configuraciones().ip}/usuarios/crear/chat');
                        var data = {
                          "numero1": numero,
                          "numero2": _controlador_numero.text,
                        };
                        var cuerpo = json.encode(data);
                        var respuesta = await http.post(url,
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: cuerpo);
                        var responseBody = json.decode(respuesta.body);
                        if (respuesta.statusCode == 200) {
                          Navigator.pop(context);
                          alerta.show(context, "Se ingreso con exito");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => inicio_chats(),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          alerta.show(context, responseBody["descripcion"]);
                        }
                      } else {
                        alerta.show(context, "Rellene los datos");
                      }
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
                    child: Text("Crear")),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    Obtener_datos();
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
                Container(
                  margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      registro(context);
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
          // Contenido de la pestaña "Profile"
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: MemoryImage(imagen),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: !load
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    flex: 2,
                    child: !load
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                numero,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Arial',
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                correo,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                nombre,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Arial',
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                tipo,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
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
