class TablaVisitas {

  static const String nombreTable = 'visitas';

  static const String id = '_id';
  static const String fecha = 'fecha';
  static const String propiedad = 'id_propiedad';
  static const String cliente = 'id_cliente';
  static const String cancelada = 'cancelada';

  static const List<String> columnas = [id, fecha, propiedad, cliente, cancelada];

}

class Visita {
  
  int? id;
  DateTime fecha;
  int propiedadId;
  int clienteId;
  bool cancelada;
  
Visita({
    this.id,
    required this.fecha,
    required this.propiedadId,
    required this.clienteId,
    required this.cancelada,
  });

  factory Visita.fromMap(Map<String, Object?> mapa) {
    return Visita(
      id: mapa[TablaVisitas.id] as int?,
      fecha: DateTime.parse(mapa[TablaVisitas.fecha] as String),      
      propiedadId: mapa[TablaVisitas.propiedad] as int,
      clienteId: mapa[TablaVisitas.cliente]as int,
      cancelada: mapa[TablaVisitas.cancelada] as int != 0            
    );
  }

   Map<String, Object?> toMap() {
    return {
      TablaVisitas.id: id,
      TablaVisitas.fecha: fecha.toIso8601String(),
      TablaVisitas.propiedad: propiedadId,
      TablaVisitas.cliente: clienteId,
      TablaVisitas.cancelada: cancelada ? 1 : 0,
    };
  }

}