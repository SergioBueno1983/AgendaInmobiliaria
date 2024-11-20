

import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class BaseDatos{

    static final BaseDatos _instancia = BaseDatos._inicializar();

    Database? _baseDatos;
    BaseDatos._inicializar();

    factory BaseDatos(){
     return _instancia;

    }

    Future<Database> obtenerBaseDatos() async {
        if(_baseDatos != null) return _baseDatos!;

        final String rutaDirectorioBD= await getDatabasesPath();
        final String rutaArchivoBD = join(rutaDirectorioBD, 'inmobiliaria_bios.sqlite');


        _baseDatos = await openDatabase(

            rutaArchivoBD,
            version:1,
            onCreate: (db, version) async{
                 db.execute('''
                CREATE TABLE ${TablaClientes.nombreTable}(
                    ${TablaClientes.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                    ${TablaClientes.nombre} TEXT NOT NULL,
                    ${TablaClientes.telefono} TEXT NOT NULL
                );
                ''');
              await  db.execute('''
                CREATE TABLE ${TablaTipos.nombreTable}(
                    ${TablaTipos.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                    ${TablaTipos.nombre} TEXT NOT NULL UNIQUE,
                    ${TablaTipos.activo} INTEGER NOT NULL
                );
                ''');

              await  db.execute('''
                CREATE TABLE ${TablaPropiedades.nombreTabla} (
                  ${TablaPropiedades.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                  ${TablaPropiedades.padron} INTEGER NOT NULL UNIQUE,
                  ${TablaPropiedades.zona} TEXT NOT NULL,
                  ${TablaPropiedades.direccion} TEXT NOT NULL,
                  ${TablaPropiedades.superficie} REAL,
                  ${TablaPropiedades.alquila} INTEGER,
                  ${TablaPropiedades.vende} INTEGER,
                  ${TablaPropiedades.precio} REAL,
                  ${TablaPropiedades.tipo} INTEGER NOT NULL,
                  ${TablaPropiedades.cliente} INTEGER NOT NULL,
                  FOREIGN KEY (${TablaPropiedades.tipo}) REFERENCES ${TablaTipos.nombreTable}(${TablaTipos.id}),
                  FOREIGN KEY (${TablaPropiedades.cliente}) REFERENCES ${TablaClientes.nombreTable}(${TablaClientes.id})
                );
                ''');

              await  db.execute('''
                CREATE TABLE ${TablaVisitas.nombreTable} (
                    ${TablaVisitas.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                    ${TablaVisitas.fecha} TEXT NOT NULL,
                    ${TablaVisitas.cancelada} INTEGER NOT NULL,
                    ${TablaVisitas.propiedad} INTEGER NOT NULL,
                    ${TablaVisitas.cliente} INTEGER NOT NULL,
                    FOREIGN KEY (${TablaVisitas.propiedad}) REFERENCES ${TablaPropiedades.nombreTabla}(${TablaPropiedades.id}),
                    FOREIGN KEY (${TablaVisitas.cliente}) REFERENCES ${TablaClientes.nombreTable}(${TablaClientes.id})
                    ); 
                ''');

              await  db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Juan Mendez', '11223344');
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Luis Dones', '13323344');
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Gonzalo Morena', '14423344');
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Raul Martinez', '15523344');
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Esteban Rodriguez', '16623344');
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Ramon Fagundez', '17723344');
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Fernando Piriz', '18823344');
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Jose Perez', '19923344');
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Pedro Lopez', '10023344');
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Juan', '11223344');
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaClientes.nombreTable}
                    VALUES (NULL, 'Juan', '11223344');
                ''');                          
                
               await db.execute('''
                    INSERT INTO ${TablaTipos.nombreTable}
                    VALUES (NULL, 'Casa', 1);
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaTipos.nombreTable}
                    VALUES (NULL, 'Apartamento', 1);
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaTipos.nombreTable}
                    VALUES (NULL, 'Chacra', 1);
                ''');                          
               await db.execute('''
                    INSERT INTO ${TablaTipos.nombreTable}
                    VALUES (NULL, 'Terreno', 1);
                ''');
               await db.execute('''
                    INSERT INTO ${TablaPropiedades.nombreTabla}
                    VALUES (NULL, 10, 'Buceo', 'Calle 1 y Calle 2', 70, 1, 0, 35000, 1, 2);
                ''');
                await db.execute('''
                  INSERT INTO ${TablaPropiedades.nombreTabla}
                  VALUES (NULL, '11', 'Pocitos', 'Avenida X', 80, 1, 0, 40000, 2, 2);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaPropiedades.nombreTabla}
                  VALUES (NULL, '12', 'Carrasco', 'Calle Y', 120, 0, 1, 60000, 3, 3);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaPropiedades.nombreTabla}
                  VALUES (NULL, '13', 'Centro', 'Calle Z', 50, 1, 0, 30000, 1, 3);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaPropiedades.nombreTabla}
                  VALUES (NULL, '14', 'Malvin', 'Avenida W', 90, 1, 1, 55000, 2, 4);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaPropiedades.nombreTabla}
                  VALUES (NULL, '15', 'Cordón', 'Calle V', 60, 0, 1, 32000, 3, 4);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaPropiedades.nombreTabla}
                  VALUES (NULL, '16', 'Punta Carretas', 'Rambla', 110, 1, 0, 58000, 1, 5);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaPropiedades.nombreTabla}
                  VALUES (NULL, '17', 'La Blanqueada', 'Avenida U', 75, 0, 1, 38000, 2, 1);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaPropiedades.nombreTabla}
                  VALUES (NULL, '18', 'Prado', 'Avenida T', 100, 1, 1, 50000, 3, 1);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaPropiedades.nombreTabla}
                  VALUES (NULL, '19', 'Sayago', 'Calle S', 55, 0, 0, 28000, 1, 4);
                ''');
                await db.execute('''
                  INSERT INTO ${TablaVisitas.nombreTable}
                  VALUES (NULL, '2023-12-10 10:00:00.0', 0, 1, 1);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaVisitas.nombreTable}
                  VALUES (NULL, '2023-12-11 14:30:00.0', 1, 2, 2);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaVisitas.nombreTable}
                  VALUES (NULL, '2023-12-12 15:45:00.0', 0, 3, 3);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaVisitas.nombreTable}
                  VALUES (NULL, '2023-12-13 11:15:00.0', 1, 4, 4);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaVisitas.nombreTable}
                  VALUES (NULL, '2023-12-14 13:00:00.0', 0, 5, 5);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaVisitas.nombreTable}
                  VALUES (NULL, '2023-12-15 14:30:00.0', 1, 6, 6);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaVisitas.nombreTable}
                  VALUES (NULL, '2023-12-16 09:45:00.0', 0, 7, 7);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaVisitas.nombreTable}
                  VALUES (NULL, '2023-12-17 12:20:00.0', 1, 8, 8);
                ''');

                await db.execute('''
                  INSERT INTO ${TablaVisitas.nombreTable}
                  VALUES (NULL, '2023-12-18 17:00:00.000', 0, 9, 9);
                ''');                                          
            },
        );

        return _baseDatos!;

    }

    Future<void> cerrarBaseDatos()async{
    await _baseDatos?.close();
    _baseDatos = null;
  }
}