import 'package:flutter/material.dart';

class ContenedorListas extends StatefulWidget {
  

  final Widget child;
  final Widget filtro;
  final String ruta;
  
  const ContenedorListas({super.key, required this.child, required this.filtro ,required this.ruta});

  @override
  State<ContenedorListas> createState() => _ContenedorListasState();
}

class _ContenedorListasState extends State<ContenedorListas> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
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
          child: Column(
            children: [
              Row(                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(child: widget.filtro),
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: ()=>Navigator.of(context).pushNamed(widget.ruta),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
                ),
              Expanded(
                child: widget.child
              ),
            ]
          )
        )
    );
  }
}