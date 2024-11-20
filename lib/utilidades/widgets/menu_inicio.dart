import 'package:flutter/material.dart';

class MenuInicio extends StatelessWidget {
  const MenuInicio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if(MediaQuery.of(context).orientation.index==1)
        SizedBox(
          height: MediaQuery.of(context).size.height *0.2,
          width: MediaQuery.of(context).size.width *0.2,
          child: const DrawerHeader(       
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(161, 27, 147, 105),
            ),
            child: Text('MENU', style: TextStyle( color: Colors.black, fontSize: 20),),
          ),
        )
         else
          SizedBox(
          height: MediaQuery.of(context).size.height *0.1,
          width: MediaQuery.of(context).size.width *0.2,
          child: const DrawerHeader(       
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(161, 27, 147, 105),
            ),
            child: Text('MENU', style: TextStyle( color: Colors.black, fontSize: 20),),
          ),
        ),
         ListTile(
          title: const Text('Clientes', style: TextStyle(fontStyle: FontStyle.italic),
          ),
          onTap: (){
            Navigator.of(context).pop();
            Navigator.of(context).popUntil((route) => route.settings.name == '/lista_visitas');
            Navigator.of(context).pushNamed('/lista_clientes');
          },
        ),
         ListTile(
          title: const Text('Propiedades', style: TextStyle(fontStyle: FontStyle.italic),),
          onTap: (){
            Navigator.of(context).pop();
            Navigator.of(context).popUntil((route) => route.settings.name == '/lista_visitas');
            Navigator.of(context).pushNamed('/lista_propiedades');
          },
        ),
         ListTile(
          title: const Text('Tipos', style: TextStyle(fontStyle: FontStyle.italic),),
          onTap:(){
            Navigator.of(context).pop();
            Navigator.of(context).popUntil((route) => route.settings.name == '/lista_visitas');
            Navigator.of(context).pushNamed('/lista_tipos');
          },
        ),
        ],
    );
  }
}