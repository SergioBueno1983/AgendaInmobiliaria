
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obligatorio_flutter/daos/dao_clientes.dart';
import 'package:obligatorio_flutter/daos/dao_propiedades.dart';
import 'package:obligatorio_flutter/daos/dao_visitas.dart';
import 'package:obligatorio_flutter/utilidades/widgets/app_bar_generica.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';


class AgendarVisita extends StatefulWidget {

  final String titulo;
  const AgendarVisita({super.key, required this.titulo});

  @override
  State<AgendarVisita> createState() => _AgendarVisitaState();
}

class _AgendarVisitaState extends State<AgendarVisita> {

  final GlobalKey<FormState> _calveFormulario=GlobalKey<FormState>();

  DateFormat formateadorFecha=DateFormat('dd/MM/yyyy');
  DateFormat formatearHora = DateFormat('HH:mm');

  late DateTime fechaHora;
  TimeOfDay hora= TimeOfDay.now();


  Cliente? _cliente;
  List<Cliente> _clientes=[];
  Propiedad? _propiedad;
  List<Propiedad> _propiedades=[];


  @override
  void initState() {

    DateTime fechaHoraActual= DateTime.now();
    fechaHora = DateTime(fechaHoraActual.year, fechaHoraActual.month,fechaHoraActual.day);
    DAOPropiedades().listarPropiedades().then((value) {
      _propiedades=value;
    });
    DAOClientes().listarClientes().then((value){
      _clientes=value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const AppBarGenerica(titulo: 'Agendar visita'),
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
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _calveFormulario,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,                     
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: ListTile(
                    title: const Text('Fecha '),
                    subtitle: Text(formateadorFecha.format(fechaHora)),
                    trailing: const Icon(Icons.calendar_month_outlined),
                    onTap: () async {
                          DateTime? fechaSeleccionada = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1981, 1, 1),
                            lastDate: DateTime(2050, 12, 31),
                            initialDate: fechaHora,
                          );
                          if (fechaSeleccionada != null) {
                            setState(() {
                              fechaHora = fechaSeleccionada;
                            });
                          }
                        },                          
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: ListTile(
                    title: const Text('Hora'),
                    subtitle: Text(hora.format(context)),
                    trailing:const Icon(Icons.watch_later_outlined),
                    onTap: () async {
                        TimeOfDay? horaSeleccionada = await showTimePicker(
                            context: context, initialTime: hora);
                        if (horaSeleccionada != null) {
                          setState(() {
                            hora = horaSeleccionada;
                          });
                        }
                      },                 
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,                     
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: ListTile(
                    title: const Text('Propiedad'),
                    onTap: (){
                            setState(() {
                              mostrarPropiedades(context);
                            });
                          },
                    subtitle: _propiedad != null ? Text('Padron : ${_propiedad!.padron}') : const Text('Seleccione una Propiedad.'),
                    trailing: const Icon(Icons.list_alt_outlined),
                        
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,                     
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: ListTile(
                    title: const Text('Cliente'),
                    onTap: (){
                            setState(() {
                              mostrarClientes(context);
                            });
                          },
                    subtitle: _cliente != null ? Text('Nombre: ${_cliente!.nombre}') : const Text('Seleccione un Cliente.'),
                    trailing: const Icon(Icons.list_alt_outlined),
                        
                  ),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  child: const Text('Agendar'),
                  onPressed: (){
                    fechaHora= DateTime(
                      fechaHora.year,
                      fechaHora.month,
                      fechaHora.day,
                      hora.hour,
                      hora.minute
                    );
                if(_calveFormulario.currentState?.validate() ?? false){
                  if(fechaHora.isBefore(DateTime.now())){
                    mostrarSnackBar(context, 'La fecha y hora no pueden ser anteriores a la fecha y hora actual.');
                    return;
                  }
                  if(_propiedad== null){
                    mostrarSnackBar(context, 'Debe elegir una propiedad.');
                    return;
                  }
                  if(_cliente==null){
                    mostrarSnackBar(context, 'Debe seleccionar un cliente.');
                    return;
                  }
                  if(_propiedad!.clienteId == _cliente!.id){
                    mostrarSnackBar(context, 'El dueño de la propiedad no puede visitar su propiedad.');
                    return;
                  }
                  
                    _calveFormulario.currentState?.save();
                    DAOVisitas().agregarVisita(Visita(fecha: fechaHora, propiedadId: _propiedad!.id!, clienteId: _cliente!.id!, cancelada: false));
                    Navigator.of(context).popUntil((route) => route.settings.name == '/lista_visitas');
                    mostrarSnackBar(context, 'Visita agendada correctamente.');                      
                }
                },
                ),
              ],
            ),
          ),
                    ),
        ),
      ),
    );
    
  }

  void mostrarPropiedades(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.separated(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _propiedad=_propiedades[index];
                          Navigator.of(context).pop();
                        });
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(_propiedades[index].padron.toString()),
                          subtitle: Text(_propiedades[index].direccion),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const Divider(height: 0),
                    itemCount: _propiedades.length,
                  ),
        )
      )
    );
  }
  void mostrarClientes(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.separated(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _cliente=_clientes[index];
                          Navigator.of(context).pop();
                        });
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(_clientes[index].id.toString()),
                          subtitle: Text(_clientes[index].nombre),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const Divider(height: 0),
                    itemCount: _clientes.length,
                  ),
        )
      )
    );
  }
  void mostrarSnackBar(BuildContext context, String mensaje){    
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content:  Text(mensaje), 
        backgroundColor:  const Color.fromARGB(179, 14, 31, 26),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        duration:  const Duration(seconds: 4),       
      )
    );
  }


}