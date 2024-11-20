import 'package:flutter/material.dart';

class PaginaNoDisponible extends StatelessWidget {
  const PaginaNoDisponible({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página no encontrada'),
      ),
      body: const Center(
        child: Text('La página solicitada no fue encontrada.'),
      ),
    );
  }
}