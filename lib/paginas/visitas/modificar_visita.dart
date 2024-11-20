import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obligatorio_flutter/daos/dao_visitas.dart';
import 'package:obligatorio_flutter/utilidades/widgets/app_bar_generica.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';

class ModificarVisita extends StatefulWidget {
  
  const ModificarVisita({super.key});

  @override
  State<ModificarVisita> createState() => _ModificarVisitaState();
}

class _ModificarVisitaState extends State<ModificarVisita> {




  late Visita _visita;
  final GlobalKey<FormState> _calveFormulario=GlobalKey<FormState>();
  DateFormat formateadorFecha=DateFormat('dd/MM/yyyy');

  late DateTime fechaHora;
  TimeOfDay hora= TimeOfDay.now();


  @override
  void didChangeDependencies() {
     _visita = ModalRoute.of(context)!.settings.arguments as Visita;
    fechaHora = _visita.fecha;
    hora=TimeOfDay.fromDateTime(_visita.fecha);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const AppBarGenerica(titulo: 'Modificar visita'),
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
                          context: context,
                          initialTime: hora
                        );
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
                const SizedBox(height: 10,),
                ElevatedButton(
                  child: const Text('Modificar'),
                  onPressed: (){
                    fechaHora= DateTime(
                      fechaHora.year,
                      fechaHora.month,
                      fechaHora.day,
                      hora.hour,
                      hora.minute
                    );
                if(_calveFormulario.currentState?.validate() ?? false ){
                  if(fechaHora.isBefore(DateTime.now())){
                    mostrarSnackBar(context, 'La fecha y hora no pueden ser anteriores a la fecha y hora actual.');
                    return;
                  }                   
                    _calveFormulario.currentState?.save();
                    _visita.fecha=fechaHora;
                    DAOVisitas().modificarVisita(_visita);
                    Navigator.of(context).popUntil((route) => route.settings.name == '/lista_visitas');
                    mostrarSnackBar(context, 'Visita modificada correctamente');
                                                           
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