import 'package:flutter/material.dart';

class widget_chat extends StatefulWidget {
  String logo;
  String mensaje;
  widget_chat({required this.logo, required this.mensaje});

  @override
  State<widget_chat> createState() => _widget_chatState();
}

class _widget_chatState extends State<widget_chat> {
  _widget_chatState();

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
              width:0.5,
            ),
          ),
          child: CircleAvatar(
            radius: 40.0,
            child: Image.network(
              widget.logo,
              width: 75,
              height: 75,
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.white,
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
            )
           
            
          ],
        )
      ],
    );
  }
}
