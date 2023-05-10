import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lines/chats.dart';

class login_modulo extends StatelessWidget {
  login_modulo({super.key});
  TextEditingController _controlador_correo = TextEditingController();
  TextEditingController _controlador_password = TextEditingController();

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
                    controller: _controlador_correo,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ingresa tu correo',
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      inicio_chats()
                    ));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20)
                      ),
                    ),
                  ),
                  child: Text("Ingresar")),
            )
          ],
        ),
      )),
    );
  }
}
