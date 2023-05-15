import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lines/chat/widgets/mensaje.dart';
import 'package:lines/configuraciones/alertas.dart';
import '../../configuraciones/configuraciones.dart';

class vista_mensaje extends StatefulWidget {
  final int id_chat;
  final String numero1;
  final String numero2;
  vista_mensaje(
      {required this.id_chat, required this.numero1, required this.numero2});

  @override
  State<vista_mensaje> createState() => _vista_mensajeState();
}

class _vista_mensajeState extends State<vista_mensaje> {
  List<Widget> mensajes = [];
  TextEditingController _controlador_mensaje = TextEditingController();

  Future<void> obtener_mensajes() async {
    var url =
        Uri.parse('${configuraciones().ip}/chats/datos/${widget.id_chat}');
    var respuesta = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    var response = json.decode(respuesta.body);
    if (respuesta.statusCode == 200) {
      List<Widget> mensajes_aux = [];
      for (var i = 0; i < response.length; i++) {
        print(response[i]["hora"]);
        Widget q = ChatMessageWidget(
          message: response[i]["descripcion"],
          date: response[i]["hora"],
          image: response[i]["imagen"],
        );
        mensajes_aux.add(q);
      }
      setState(() {
        mensajes = mensajes_aux;
      });
    }
  }

  Future<void> ingresar_mensajes() async {
    var url = Uri.parse('${configuraciones().ip}/chats/ingresar/mensaje');
    var data = {
      "id_chat": widget.id_chat,
      "numero": widget.numero1,
      "descripcion": _controlador_mensaje.text
    };
    var cuerpo = jsonEncode(data);
    var respuesta = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: cuerpo);
    if (respuesta.statusCode == 200) {
      var response = json.decode(respuesta.body);
      print(response);
    }
  }

  @override
  void initState() {
    obtener_mensajes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 20, left: 10),
                children: mensajes,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controlador_mensaje,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (_controlador_mensaje.text != "" &&
                          _controlador_mensaje.text != null) {
                        ingresar_mensajes();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => vista_mensaje(id_chat: widget.id_chat,numero1: widget.numero1,numero2: widget.numero2,)),
                        );
                      } else {
                        alerta.show(context, "Ingrese un mensaje");
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
