import 'package:flutter/material.dart';
import 'package:lines/configuraciones/convertidor.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final String date;
  final String image;

  ChatMessageWidget({required this.message, required this.date, required this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: MemoryImage(convertidor().convertToUint8List(this.image))
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Padding(padding: EdgeInsets.only(bottom: 10),child:  Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              )
             
            ],
          ),
        ),
      ],
    );
  }
}
