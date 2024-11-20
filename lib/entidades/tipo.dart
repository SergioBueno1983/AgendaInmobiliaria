class TablaTipos {

  static const String nombreTable = 'tipos';
  
  static const String id = '_id';
  static const String nombre = 'nombre';
  static const String activo = 'activo';
  
  static const List<String> columnas = [id, nombre];

}


class Tipo {

  int? id;
  String nombre;
  bool activo =true;

  Tipo({this.id, required this.nombre, required this.activo});

  factory Tipo.fromMap(Map<String, Object?> mapa) {
    return Tipo(
      id: mapa[TablaTipos.id] as int?,
      nombre: mapa[TablaTipos.nombre] as String,
      activo: mapa[TablaTipos.activo] as int != 0,
      );
  }

  Map<String, Object?> toMap() {
    return {
      TablaTipos.id: id,
      TablaTipos.nombre: nombre,
      TablaTipos.activo: activo,
    };
  }
   
}