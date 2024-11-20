import 'package:flutter/material.dart';
import 'package:obligatorio_flutter/daos/base_datos.dart';
import 'package:obligatorio_flutter/daos/dao_propiedades.dart';
import 'package:obligatorio_flutter/daos/dao_tipos.dart';
import 'package:obligatorio_flutter/utilidades/widgets/app_bar_generica.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';
import 'package:obligatorio_flutter/utilidades/widgets/mensajes.dart';
import 'package:obligatorio_flutter/utilidades/widgets/menu_inicio.dart';

class ListaTipos extends StatefulWidget {
  const ListaTipos({super.key});

  @override
  State<ListaTipos> createState() => _ListaTiposState();
}

class _ListaTiposState extends State<ListaTipos> {
  
  List<Tipo> _tipos=[];
  List<Propiedad> _propiedades=[];

  @override
  initState() {
    super.initState();
    DAOTipos().listarTiposActivos().then((tipos) {
      setState(() {
        _tipos = tipos;
      });    
    });
    DAOPropiedades().listarPropiedades().then((value) {
      _propiedades= value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer:  const SafeArea(
        child: Drawer(
          child: MenuInicio()
        ),
      ),
      appBar: const AppBarGenerica(titulo: 'Lista de Tipos'),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'imagenes/fondo_inmo.jpg',                
              ),
              fit: BoxFit.cover
            ),
          ),
          child: Column(
            children: [
               Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: ()=>Navigator.of(context).pushNamed('/agregar_tipo'),
                  child: const Icon(Icons.add),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      title: Text(_tipos[index].nombre),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/modificar_tipo', arguments: _tipos[index] );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed:() => mostrarEliminarTipo(context, 'Eliminar tipo', 'Desea eliminar el tipo de propiedad ${_tipos[index].nombre}', _tipos[index]), 
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                  itemCount: _tipos.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Propiedad? comprobarPropiedades(Tipo tipo) {
    Propiedad? propiedadEncontrada;

    for (Propiedad p in _propiedades) {
      if (p.tipoId == tipo.id){
        propiedadEncontrada = p;
        break;
      }                   
    } 

    return propiedadEncontrada;
  }

  void mostrarEliminarTipo(BuildContext context, String titulo, String mensaje, Tipo tipo) {
    showDialog(      
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No')),
          TextButton(
              onPressed: () {
                Propiedad? propiedadEncontrada;
                propiedadEncontrada = comprobarPropiedades(tipo);
                setState(() {
                  if (propiedadEncontrada == null) { //si no tiene propiedades asociadas elimino
                    DAOTipos().eliminarTipo(tipo.id!);
                  } else { //si tiene propiedades asociadas baja logica
                    tipo.activo = false;
                    DAOTipos().modificarTipo(tipo);
                  }                                  
                  _tipos.remove(tipo);
                  Mensajes.mostrarSnackBar(context,'Tipo elimindo con exito ');
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Si')),
            ],
          )
      );
  }

  
    @override
    void dispose(){
      BaseDatos().cerrarBaseDatos();
      super.dispose();
  }
  
}