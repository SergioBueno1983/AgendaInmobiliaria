import 'package:flutter/material.dart';

class AppBarGenerica extends StatelessWidget implements PreferredSizeWidget{
  final String titulo;
  const AppBarGenerica({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.settings.name == '/lista_visitas');
              Navigator.of(context).pushReplacementNamed('/lista_visitas');
            },
          ),
        ],
        
      );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}