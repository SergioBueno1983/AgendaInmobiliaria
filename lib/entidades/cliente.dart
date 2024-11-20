class TablaClientes{

  static const String nombreTable='Clientes';
  static const String id = '_id';
  static const String nombre= '_nombre';
  static const String telefono='_telefono';

  static const List<String> columnas=[id,nombre,telefono];

}

class Cliente {
  
  int? id;
  String nombre;
  String telefono;

  Cliente({this.id, required this.nombre, required this.telefono});

  factory Cliente.fromMap(Map<String, Object?> mapa){
    return Cliente(
      id: mapa[TablaClientes.id] as int,
      nombre: mapa[TablaClientes.nombre] as String, 
      telefono: mapa[TablaClientes.telefono] as String);
  }
   Map<String,Object?> toMap(){
    return{
      TablaClientes.id:id,
      TablaClientes.nombre:nombre,
      TablaClientes.telefono:telefono,
    };

   }


  

}