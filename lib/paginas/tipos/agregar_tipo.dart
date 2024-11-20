import 'package:flutter/material.dart';
import 'package:obligatorio_flutter/daos/dao_tipos.dart';
import 'package:obligatorio_flutter/utilidades/widgets/app_bar_generica.dart';
import 'package:obligatorio_flutter/utilidades/widgets/contenedor_personalizado.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';
import 'package:obligatorio_flutter/utilidades/widgets/mensajes.dart';
import 'package:obligatorio_flutter/utilidades/validaciones.dart';
import 'package:sqflite/sqflite.dart';

class AgregarTipo extends StatefulWidget {
  const AgregarTipo({super.key});

  @override
  State<AgregarTipo> createState() => _AgregarTipoState();
}

class _AgregarTipoState extends State<AgregarTipo> {

  final GlobalKey<FormState> _calveFormulario=GlobalKey<FormState>();

  Tipo? tipo;
  String? _nombre;
  List<Tipo>? _tipos;

  @override
  void initState() {
    DAOTipos().listarTipos().then((value) {
      _tipos = value;
    });
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const AppBarGenerica(titulo: 'Agregar Tipo',),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ContenedorPersonalizado(
                child: TextFormField(
                    decoration: const InputDecoration(
                    label: Text('Nombre'),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red,width: 2)
                  ),        
                  ),
                  validator: (value) => Validaciones.validarNombreTipo(value),
                  onSaved: (newValue){
                    _nombre=newValue!.trim();
                  },
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  if(_calveFormulario.currentState?.validate() ?? false){
                      _calveFormulario.currentState?.save();
                      Tipo? tipoEncontrado = compararNombreTipo(_nombre!);
                      if(tipoEncontrado == null) {
                        tipo = Tipo(nombre: _nombre!, activo: true);                            
                        try {  
                          DAOTipos().agregarTipo(tipo!);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed('/lista_tipos');
                          mostrarSnackBar(context, 'Tipo de propiedad agregado correctamente');  
                        } on DatabaseException {                            
                            Mensajes.mostrarAlertDialog(context,'El Nombre ${tipo!.nombre} ya existe.');                                            
                        }
                      } else {
                        if (tipoEncontrado.activo) {
                          Mensajes.mostrarAlertDialog(context, 'El tipo con ese nombre ya existe');
                          return;
                        }
                        else {
                          tipoEncontrado.activo = true;
                          DAOTipos().modificarTipo(tipoEncontrado);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed('/lista_tipos');
                          mostrarSnackBar(context, 'Tipo de propiedad agregado correctamente');  
                        }
                      }        
                  }
                },
                child: const Icon(Icons.save),
                ), 
            ],
          )
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
        duration:  const Duration(seconds: 2),       
      )
    );
  }
  
  Tipo? compararNombreTipo(String tipo) {
    Tipo? tipoEncontrado;

    for(Tipo t in _tipos!) {
     if (t.nombre == tipo) {
      tipoEncontrado = t;
      
     }
    }   
    return tipoEncontrado ;
  }
}