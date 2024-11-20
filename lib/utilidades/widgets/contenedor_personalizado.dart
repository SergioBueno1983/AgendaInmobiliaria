import 'package:flutter/material.dart';

class ContenedorPersonalizado extends StatelessWidget {

  final Widget child;

  const ContenedorPersonalizado({super.key, required this.child});

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,                     
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: child,
    );
  }
}