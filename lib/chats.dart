import 'package:flutter/material.dart';
import 'chatmodulo.dart';

class inicio_chats extends StatefulWidget {
  @override
  _inicio_chat createState() => _inicio_chat();
}

class _inicio_chat extends State<inicio_chats> {
  
  int indice = 0;
  List<Widget> chats = [];

  @override
  void initState() {
    Widget q = widget_chat(
      logo: "https://logos.textgiraffe.com/logos/logo-name/Juan-designstyle-smoothie-m.png",
      mensaje: "s",
    );
    chats.add(q);
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
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 25),
                width: double.infinity,
                color: Colors.purple,
                padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
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
          // Contenido de la pestaña "Profile"
          Center(
            child: Text(
              'Hola',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: indice,
        onTap: navegacion_indice,
      ),
    );
  }
}
