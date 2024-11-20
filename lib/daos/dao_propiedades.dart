import 'package:obligatorio_flutter/daos/base_datos.dart';
import 'package:obligatorio_flutter/daos/dao_clientes.dart';
import 'package:obligatorio_flutter/entidades/propiedad.dart';
import 'package:obligatorio_flutter/entidades/visita.dart';
import 'package:sqflite/sqflite.dart';

class DAOPropiedades {

  static final DAOPropiedades _instancia = DAOPropiedades._inicializar();

  DAOPropiedades._inicializar();

  factory DAOPropiedades() {
    return _instancia;
  }

  Future<List<Propiedad>> listarPropiedades() async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    List<Map<String, Object?>> mapasPropiedades = await bd.query(
      TablaPropiedades.nombreTabla,
      orderBy: TablaPropiedades.padron,
      );

    return mapasPropiedades.map((mp) {
      DAOClientes().obtenerCliente(mp[TablaPropiedades.cliente] as int);
      return Propiedad.fromMap(mp);
    }).toList();
  }
  Future<List<Object>> listarZona() async {
    Database bd = await BaseDatos().obtenerBaseDatos();

      List<Map<String, Object?>> mapasZona = await bd.query(
      TablaPropiedades.nombreTabla,
      columns: [TablaPropiedades.zona],
      orderBy: TablaPropiedades.zona,
      );
      return mapasZona;

   
  }
  Future<List<Propiedad>> listarPropiedadesPorCliente( int idCliente) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    List<Map<String, Object?>> mapasPropiedades = await bd.query(
      TablaPropiedades.nombreTabla,
      where: '${TablaPropiedades.cliente} = ?',
      whereArgs: [idCliente],
      orderBy: TablaPropiedades.padron,
      );

    return mapasPropiedades.map((mp) {
      DAOClientes().obtenerCliente(mp[TablaPropiedades.cliente] as int);
      return Propiedad.fromMap(mp);
    }).toList();
  }

  Future<Propiedad?> obtenerPropiedad(int id) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    List<Map<String, Object?>> mapasPropiedades = await bd.query(
      TablaPropiedades.nombreTabla,
      where: '${TablaPropiedades.id} = ?',
      whereArgs: [id],
    ); 

    return mapasPropiedades.isNotEmpty ? Propiedad.fromMap(mapasPropiedades.first) : null;
  }

  Future<int> agregarPropiedad(Propiedad propiedad) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.insert(TablaPropiedades.nombreTabla, propiedad.toMap());
  }

  Future<int> modificarPropiedad(Propiedad propiedad) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.update(
      TablaPropiedades.nombreTabla, 
      propiedad.toMap(),
      where: '${TablaPropiedades.id} = ?',
      whereArgs: [propiedad.id],
    );
  }

  Future<int> eliminarPropiedad(int id) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.transaction((txn) async {
     final int visitasEliminadas= await txn.delete(
        TablaVisitas.nombreTable, 
      where: '${TablaVisitas.propiedad} = ?',
      whereArgs: [id]
      );
      
      final int propiedadesEliminadas= await txn.delete(
        TablaPropiedades.nombreTabla,
        where: '${TablaPropiedades.id}=?',
        whereArgs: [id],
      );

      return visitasEliminadas + propiedadesEliminadas;
      
  }
  );
  }
}