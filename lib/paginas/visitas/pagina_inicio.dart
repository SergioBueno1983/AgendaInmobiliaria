

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obligatorio_flutter/daos/base_datos.dart';
import 'package:obligatorio_flutter/daos/dao_clientes.dart';
import 'package:obligatorio_flutter/daos/dao_propiedades.dart';
import 'package:obligatorio_flutter/daos/dao_visitas.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';
import 'package:obligatorio_flutter/utilidades/widgets/mensajes.dart';
import 'package:obligatorio_flutter/utilidades/widgets/menu_inicio.dart';


class PaginaInicio extends StatefulWidget {

  const PaginaInicio({super.key,});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {

  int _indicePestaniaActual=0;
  
  DateFormat formateadorFecha=DateFormat('dd/MM/yyyy');
  DateFormat formateadorHora = DateFormat('HH:mm');

  late DateTime _fechaSeleccionada;

  Propiedad? _propiedad;
  List<Cliente> _clientes=[];
  List<Propiedad> _propiedades=[];


  @override
  initState() {
    _fechaSeleccionada=DateTime.now();
    formateadorFecha.format(_fechaSeleccionada);
    DAOPropiedades().listarPropiedades().then((value) {
      setState(() {
        _propiedades = value;
      });
    });
    DAOVisitas().listarVisitas(_fechaSeleccionada).then((value) {
      setState(() {
      });
    });
    DAOClientes().listarClientes().then((value) {
      _clientes= value;
    });

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      drawer: const SafeArea(
        child: Drawer(
          child: MenuInicio()
        ),
      ),
      appBar: AppBar(
        title: const Text('Inmobiliaria Bios'),
      ),
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
              const Text('Agenda del dia:', style: TextStyle(color: Color.fromARGB(255, 49, 33, 108), fontSize: 20),),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                TextButton.icon(
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text(formateadorFecha.format(_fechaSeleccionada),
                  style: const TextStyle(fontSize: 25),
                  ),
                    onPressed: () async {
                      DateTime? fechaSeleccionada = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1981, 1, 1),
                        lastDate: DateTime(2050, 12, 31),
                        initialDate: _fechaSeleccionada,
                      );
                      if (fechaSeleccionada != null) {
                        setState(() {
                          _fechaSeleccionada = fechaSeleccionada;
                        });
                      }
                    },
                    ),
                Align(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/agendar_visita').then((value) {
                          setState(() {
                            
                          });
                        }),
                    child: const Icon(Icons.add),
                  ),
                ),
              ]),
              Expanded(
                child: FutureBuilder(
                  future: _indicePestaniaActual==0 ? DAOVisitas().listarVisitasXEstado(false,_fechaSeleccionada)
                   : DAOVisitas().listarVisitas(_fechaSeleccionada),
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
                                title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                   child: Row(
                                      children: [
                                        Text(formateadorHora.format(snapshot.data![index].fecha),),
                                        const SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text('Direccion: ${_propiedades.firstWhere(
                                              (element) => element.id 
                                              == snapshot.data![index].propiedadId).direccion}'),
                                              const SizedBox(height: 5,),
                                            Text('Cliente: ${_clientes.firstWhere(
                                              (element) => element.id 
                                              == snapshot.data![index].clienteId).nombre}'),
                                          ],
                                        ),
                                        
                                      ],
                                    ),
                                  ),
                                onTap: () {
                                      DAOPropiedades().obtenerPropiedad(snapshot.data![index].propiedadId).then((propiedad) {
                                        setState(() {
                                          _propiedad = propiedad;
                                        });
          
                                        mostrarPropiedadAlertDialog(context,'${snapshot.data![index].fecha.hour.toString()}:${snapshot.data![index].fecha.minute.toString()}Hs.'
                                        , _propiedad!);  
                                      });                             
                                    },
                                trailing: snapshot.data![index].cancelada==false ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/modificar_visita', arguments: snapshot.data![index]).then((value) {
                                          setState(() {
                                            
                                          });
                                        });
                                        
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          mostrarCancelarVisita(context, 'Cancelar Visita', 'Desea cancelar la visita',snapshot.data![index]);                                            
                                        });
                                      },
                                      icon: const Icon(Icons.cancel_rounded),
                                    ),
                                  ],
                                ) : const IconButton(
                                      onPressed:null,
                                      icon: Icon(Icons.cancel_rounded),
                                    ),
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                const Divider(height: 0),
                            itemCount: snapshot.data!.length,
                            ): Center(
                              child: Text('No hay Visitas para el día: ${formateadorFecha.format(_fechaSeleccionada)}'),
                            );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('¡ERROR! No se pudo listar las tareas'),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                    }
                  },
                ),                  
              ),                
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indicePestaniaActual,
          items: const [
            BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pendientes'
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox),
            label: 'Todas'
            ),
            ],
            onTap: (value) {
              setState(() {
                _indicePestaniaActual=value;
              });
            },
        ),
    );
  }
  void mostrarCancelarVisita(BuildContext context, String titulo, String mensaje, Visita visita) {
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
                    onPressed: () { setState(() {
                      visita.cancelada=true;           
                      DAOVisitas().modificarVisita(visita);
                      Navigator.of(context).pop();   
                      Mensajes.mostrarSnackBar(context, 'Visita cancelada con exito.');                   
                    });
                      
                    },
                    child: const Text('Si')),

              ],
            ));
  }


void mostrarPropiedadAlertDialog(BuildContext context, String titulo, Propiedad propiedad) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(titulo),
              content: SingleChildScrollView(
                child: Text(
                  '''Propiedad: ${propiedad.padron}
                  \nAlquiler: ${propiedad.alquila! ? 'Si': 'No' }
                  \nVenta: ${propiedad.vende! ? 'Si': 'No' }
                  \nDireccion: ${propiedad.direccion}
                    \nPrecio: u\$s ${propiedad.precio} 
                    \nDueño:  ${_clientes.firstWhere(
                                (element) => element.id 
                                == propiedad.clienteId).nombre}'''),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Aceptar'))
              ],
            ));
  }

    @override
    void dispose(){
      BaseDatos().cerrarBaseDatos();
      super.dispose();
  }
}

