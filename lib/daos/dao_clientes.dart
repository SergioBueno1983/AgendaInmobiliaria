import 'package:obligatorio_flutter/daos/base_datos.dart';
import 'package:obligatorio_flutter/entidades/cliente.dart';
import 'package:sqflite/sqflite.dart';

class DAOClientes{

  static final DAOClientes _instancia = DAOClientes._inicializar();

  DAOClientes._inicializar();

  factory DAOClientes() {
    return _instancia;
  }

  Future<List<Cliente>> listarClientes() async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    List<Map<String, Object?>> mapasClientes = await bd.query(
      TablaClientes.nombreTable,
      orderBy: TablaClientes.nombre);

    return mapasClientes.map((mc) => Cliente.fromMap(mc)).toList();
  }

  Future<Cliente?> obtenerCliente(int id) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    List<Map<String, Object?>> mapasClientes = await bd.query(
      TablaClientes.nombreTable,
      where: '${TablaClientes.id} = ?',
      whereArgs: [id],
    ); 

    return mapasClientes.isNotEmpty ? Cliente.fromMap(mapasClientes.first) : null;
  }

  Future<int> agregarCliente(Cliente cliente) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.insert(TablaClientes.nombreTable, cliente.toMap());
  }

  Future<int> modificarCliente(Cliente cliente) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.update(
      TablaClientes.nombreTable, 
      cliente.toMap(),
      where: '${TablaClientes.id} = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<int> eliminarCliente(int id) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    return await bd.delete(
      TablaClientes.nombreTable, 
      where: '${TablaClientes.id} = ?',
      whereArgs: [id],
    );
  }
  
}