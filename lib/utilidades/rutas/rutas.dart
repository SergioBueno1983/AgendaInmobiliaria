import 'package:flutter/material.dart';
import 'package:obligatorio_flutter/paginas/pagina_no_disponible.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_paginas.dart';

class Rutas{

  static Map<String, Widget Function(BuildContext)> rutas ={
    
    '/lista_visitas':(context) => const PaginaInicio(),
    '/agendar_visita':(context)=>  const AgendarVisita(titulo: 'Agendar Visita'),
    '/modificar_visita':(context)=> const ModificarVisita(),
    
    '/lista_clientes':(context) => const ListaClientes(),
    '/agregar_cliente':(context) => const AgregarCliente(),
    '/modificar_cliente':(context) => const ModificarCliente(),

    '/lista_propiedades':(context) => const ListaPropiedades(),
    '/agregar_propiedad':(context) => const AgregarPropiedad(),
    '/modificar_propiedad':(context) => const ModificarPropiedad(),

    '/lista_tipos':(context) => const ListaTipos(),
    '/agregar_tipo':(context) => const AgregarTipo(),
    '/modificar_tipo':(context) => const ModificarTipo(),
  };

  static String rutaInicial='/lista_visitas';

  static Route<dynamic>? generadorRutas(RouteSettings settings){
    return MaterialPageRoute(
          builder:(context) => const PaginaNoDisponible(),
          settings: settings,
          );

  }

}