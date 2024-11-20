import 'package:flutter/material.dart';
import 'package:obligatorio_flutter/daos/dao_clientes.dart';
import 'package:obligatorio_flutter/daos/dao_propiedades.dart';
import 'package:obligatorio_flutter/daos/dao_visitas.dart';
import 'package:obligatorio_flutter/utilidades/widgets/app_bar_generica.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';
import 'package:obligatorio_flutter/utilidades/widgets/mensajes.dart';
import 'package:obligatorio_flutter/utilidades/widgets/menu_inicio.dart';

class ListaClientes extends StatefulWidget {
  const ListaClientes({super.key});

  @override
  State<ListaClientes> createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {

  final TextEditingController _filtroController = TextEditingController();
  List<Cliente> _clientes =[];
  List<Cliente> _clientesOriginal = [];
  List<Propiedad> _propiedades=[];
  List<Visita> _visitas=[];

@override
  void didChangeDependencies() async {
    await DAOClientes().listarClientes().then((clientes) {
      setState(() {
        _clientes = clientes;
        _clientesOriginal = clientes;
      });
    });
    await DAOPropiedades().listarPropiedades().then((value) {
      _propiedades = value;
    });
    await DAOVisitas().listarVisitasTodas().then((value) {
      _visitas = value;
    });
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  const SafeArea(
        child: Drawer(
          child: MenuInicio()
        ),
      ),
      appBar: const AppBarGenerica(titulo: 'Lista Clientes'),
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
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
              Row(                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextField(
                      
                      onTap: () {
                        _clientes = _clientesOriginal;
                      },
                      controller: _filtroController,
                      decoration: InputDecoration(                   
                        label: const Text('Filtrar'),     
                        suffixIcon: _filtroController.text.isNotEmpty
                          ? IconButton(                            
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _filtroController.clear();
                                  _clientes = _clientesOriginal;
                                  FocusScope.of(context).unfocus();
                                });
                              },
                            )
                          : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          actualizarListaClientes(value.trim());
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: ()=>Navigator.of(context).pushNamed('/agregar_cliente'),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
                ),
              Expanded(
                child: FutureBuilder(
                  future: DAOClientes().listarClientes(), 
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            return snapshot.data!.isNotEmpty
                              ? ListView.separated(
                                itemBuilder: (context, index) => Card(
                                  child: ListTile(
                                    onTap: () {
                                      mostrarClienteAlertDialog(context, _clientes[index]);
                                    },
                                    title: Text(_clientes[index].nombre),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed('/modificar_cliente', arguments: _clientes[index] );
                                          },
                                          icon: const Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              mostrarEliminarCliente(context, 'Eliminar Cliente', 'Desea Eliminar el cliente ${_clientes[index].nombre}', _clientes[index]);
                                            });
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 0),
                                itemCount: _clientes.length,
                              ) : const Center(
                                child: Text('No existen clientes en el sistema'),
                              );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text('¡ERROR! No se pudo listar las clientes'),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                    }
                  },
                ),
                
              ),
            ]
        ),
      ),
    ));
  }

  bool comprobarVinculacion(Cliente c) {
    for (Propiedad p in _propiedades) {
      if (p.clienteId == c.id){
        return true;
      }                   
    } 
    for (Visita v in _visitas) {
      if (v.clienteId == c.id){
        return true;
      }                   
    } 
    return false;
  }

  void mostrarEliminarCliente(BuildContext context, String titulo, String mensaje, Cliente cliente) {
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
            setState(() {
              if (comprobarVinculacion(cliente)) {
                Navigator.of(context).pop();
                Mensajes.mostrarAlertDialog(context,'El cliente no se puede eliminar porque tiene propiedades y/o visitas vinculadas.');
              } else {
                DAOClientes().eliminarCliente(cliente.id!);
                _clientes.remove(cliente);
                Mensajes.mostrarSnackBar(context,'Cliente elimindo con exito ');
                Navigator.of(context).pop();
              }                                  
            });
          },
          child: const Text('Si')),
      ],
      )
    );
  }

  void actualizarListaClientes(String? filtro) {
    List<Cliente> listaAux = [];
    if (filtro != null && filtro != '') {
      for (Cliente c in _clientesOriginal) {
        if (c.nombre.toLowerCase().contains(filtro.trim().toLowerCase())) {
          listaAux.add(c);
        }
      }
    } else { //si el filtro es null o vacio uso la lista original
      listaAux = _clientesOriginal;
    }
    
    _clientes = listaAux;
  }
  void mostrarClienteAlertDialog(
      BuildContext context, Cliente cliente) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Cliente Nº: ${cliente.id}'),
              content: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre: ${cliente.nombre}'),
                      Text('Telefono: ${cliente.telefono}'),

                      
                    ]),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Aceptar'))
              ],
            ));
  }
    
}
