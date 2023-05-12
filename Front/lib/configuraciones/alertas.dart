import 'package:flutter/material.dart';

class alerta {
  static void show(BuildContext context,mensaje) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Text(
              mensaje,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
