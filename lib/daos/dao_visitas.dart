import 'package:intl/intl.dart';
import 'package:obligatorio_flutter/daos/base_datos.dart';
import 'package:obligatorio_flutter/entidades/visita.dart';
import 'package:sqflite/sqflite.dart';


class DAOVisitas{

  static final DAOVisitas _instancia = DAOVisitas._inicializar();

  String? fechaSeleccionada;


  DAOVisitas._inicializar();

  factory DAOVisitas() {
    return _instancia;
  }

  Future<List<Visita>> listarVisitasTodas() async{
    Database db = await BaseDatos().obtenerBaseDatos();
    List<Map<String, Object?>> mapasVisitas = await db.query(TablaVisitas.nombreTable);
    return mapasVisitas.map((mv) => Visita.fromMap(mv)).toList();

  }

  Future<List<Visita>> listarVisitas(DateTime fecha) async {
    Database bd = await BaseDatos().obtenerBaseDatos();
    
    String fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);

    String fechaBusqueda = '$fechaFormateada%';

    List<Map<String, Object?>> mapasVisitas = await bd.query(
      TablaVisitas.nombreTable,
      where: '${TablaVisitas.fecha} LIKE ?',
      whereArgs: [fechaBusqueda],
      orderBy: TablaVisitas.fecha
    );

    return mapasVisitas.map((mv) => Visita.fromMap(mv)).toList();
  }
  

  Future<List<Visita>> listarVisitasXEstado(bool cancelada, DateTime fecha) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    String fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);
    DateTime fechaA= DateTime.now();
    String fechaActual = DateFormat('yyyy-MM-dd HH:mm').format(fechaA);

    String fechaBusqueda = '$fechaFormateada%';  

    List<Map<String, Object?>> mapasVisitas = await bd.query(
      TablaVisitas.nombreTable,
      where: '${TablaVisitas.cancelada} = ? and ${TablaVisitas.fecha} LIKE ? and ${TablaVisitas.fecha} > ?',
      whereArgs: [cancelada ? 1 : 0, fechaBusqueda, fechaActual],
      orderBy: TablaVisitas.fecha
    ); 

    return mapasVisitas.map((mv) => Visita.fromMap(mv)).toList();
  } 

  Future<Visita?> obtenerVisita(int id) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    List<Map<String, Object?>> mapasVisitas = await bd.query(
      TablaVisitas.nombreTable,
      where: '${TablaVisitas.id} = ?',
      whereArgs: [id],
    ); 

    return mapasVisitas.isNotEmpty ? Visita.fromMap(mapasVisitas.first) : null;
  }

  Future<int> agregarVisita(Visita visita) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.insert(TablaVisitas.nombreTable, visita.toMap());
  }

  Future<int> modificarVisita(Visita visita) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.update(
      TablaVisitas.nombreTable, 
      visita.toMap(),
      where: '${TablaVisitas.id} = ?',
      whereArgs: [visita.id],
    );
  }
}