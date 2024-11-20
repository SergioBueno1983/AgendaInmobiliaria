import 'package:obligatorio_flutter/daos/base_datos.dart';
import 'package:obligatorio_flutter/entidades/tipo.dart';
import 'package:sqflite/sqflite.dart';

class DAOTipos {

  static final DAOTipos _instancia = DAOTipos._inicializar();

  DAOTipos._inicializar();

  factory DAOTipos() {
    return _instancia;
  }

  Future<List<Tipo>> listarTipos() async{
    Database db = await BaseDatos().obtenerBaseDatos();
    List<Map<String, Object?>> mapasTipos = await db.query(
      TablaTipos.nombreTable,
      orderBy: TablaTipos.nombre);
    return mapasTipos.map((mt) => Tipo.fromMap(mt)).toList();

  }

  Future<List<Tipo>> listarTiposActivos() async {
    Database bd = await BaseDatos().obtenerBaseDatos();



    List<Map<String, Object?>> mapasTipos = await bd.query(
      TablaTipos.nombreTable,
      where: '${TablaTipos.activo} = ?',
      whereArgs: [1],
      orderBy: TablaTipos.nombre
    ); 

    return mapasTipos.map((mt) => Tipo.fromMap(mt)).toList();
  } 


  Future<Tipo?> obtenerTipo(int id) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    List<Map<String, Object?>> mapasTipos = await bd.query(
      TablaTipos.nombreTable,
      where: '${TablaTipos.id} = ?',
      whereArgs: [id],
    ); 

    return mapasTipos.isNotEmpty ? Tipo.fromMap(mapasTipos.first) : null;
  }

  Future<int> agregarTipo(Tipo tipo) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.insert(TablaTipos.nombreTable, tipo.toMap());
  }

  Future<int> modificarTipo(Tipo tipo) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.update(
      TablaTipos.nombreTable, 
      tipo.toMap(),
      where: '${TablaTipos.id} = ?',
      whereArgs: [tipo.id],
    );
  }

  Future<int> eliminarTipo(int id) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.delete(
      TablaTipos.nombreTable, 
      where: '${TablaTipos.id} = ?',
      whereArgs: [id],
    );
  }

}