import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lines/chat/vistamensaje.dart';
class WidgetChat extends StatefulWidget {
  Uint8List logo;
  String nombre;
  String correo;
  int id_chat;
  String numero1;
  String numero2;
  
  WidgetChat({required this.logo, required this.nombre,required this.correo,required this.id_chat,required this.numero1,required this.numero2});

  @override
  State<WidgetChat> createState() => _WidgetChatState();
}

class _WidgetChatState extends State<WidgetChat> {
  _WidgetChatState();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          child: CircleAvatar(
            radius: 40.0,
            foregroundColor: Colors.white,
            backgroundColor: Colors.white,
            backgroundImage: Image.memory(
              widget.logo,
              width: 75,
              height: 75,
            ).image,
          ),
        ),
        GestureDetector(
          child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(widget.nombre),
            ),
            Container(
              child: Text(widget.correo),
            ),
          ],
        ),
          onTap: (){
                      Navigator.push(
              context, MaterialPageRoute(builder: (context) => vista_mensaje(id_chat: widget.id_chat,numero1: widget.numero1,numero2: widget.numero2,)));
          },
        )
        
      ],
    );
  }
}
