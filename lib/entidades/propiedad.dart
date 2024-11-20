
class TablaPropiedades{

  static const String nombreTabla='Propiedades';
  static const String id = '_id';
  static const String padron = 'padron';
  static const String zona = 'zona';
  static const String direccion='direccion';
  static const String superficie='superficie';
  static const String alquila='alquila';
  static const String vende='vende';
  static const String precio='precio';
  static const String tipo='tipo';
  static const String cliente='cliente';
}

class Propiedad {
  int? id;
  int padron;
  String zona;
  String direccion;
  double? superficie;
  bool? alquila;
  bool? vende;
  double? precio;
  int tipoId;
  int clienteId; 
  


  Propiedad({
    this.id,
    required this.padron,
    required this.zona,
    required this.direccion,
    this.superficie,
    this.alquila,
    this.vende,
    this.precio,
    required this.tipoId,
    required this.clienteId,
  });

  factory Propiedad.fromMap(Map<String, Object?> mapa) {

    return Propiedad(
      id: mapa[TablaPropiedades.id] as int?,
      padron: mapa[TablaPropiedades.padron] as int,
      zona: mapa[TablaPropiedades.zona] as String,
      direccion: mapa[TablaPropiedades.direccion] as String,
      superficie: mapa[TablaPropiedades.superficie] as double?,
      alquila: mapa[TablaPropiedades.alquila] as int != 0,
      vende: mapa[TablaPropiedades.vende] as int != 0,
      precio: mapa[TablaPropiedades.precio] as double?,
      tipoId: mapa[TablaPropiedades.tipo] as int,
      clienteId: mapa[TablaPropiedades.cliente] as int,
   );
  }

  Map<String, Object?> toMap() {
    return {
      TablaPropiedades.id: id,
      TablaPropiedades.padron: padron,
      TablaPropiedades.zona: zona,
      TablaPropiedades.direccion: direccion,
      TablaPropiedades.superficie: superficie,
      TablaPropiedades.alquila: alquila,
      TablaPropiedades.vende: vende,
      TablaPropiedades.precio: precio,
      TablaPropiedades.tipo: tipoId,
      TablaPropiedades.cliente: clienteId,
    };
  }
  

}