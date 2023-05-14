import 'dart:typed_data';
import 'package:flutter/material.dart';

class WidgetChat extends StatefulWidget {
  Uint8List logo;
  String mensaje;
  
  WidgetChat({required this.logo, required this.mensaje});

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
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text("Juan Chandlers"),
            ),
            Container(
              child: Text("Que pasa"),
            ),
          ],
        ),
      ],
    );
  }
}
