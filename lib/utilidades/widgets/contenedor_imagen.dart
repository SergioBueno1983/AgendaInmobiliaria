import 'package:flutter/material.dart';

class ContenedorImagen extends StatelessWidget {

  final Widget child;

  const ContenedorImagen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'imagenes/fondo_inmo.jpg',                
            ),
            fit: BoxFit.cover
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: child,
        ),
      ),
    );
  }
}