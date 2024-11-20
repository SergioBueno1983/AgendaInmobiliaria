import 'package:flutter/material.dart';
import 'package:obligatorio_flutter/daos/dao_tipos.dart';
import 'package:obligatorio_flutter/utilidades/widgets/app_bar_generica.dart';
import 'package:obligatorio_flutter/utilidades/widgets/contenedor_imagen.dart';
import 'package:obligatorio_flutter/utilidades/widgets/contenedor_personalizado.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';
import 'package:obligatorio_flutter/utilidades/widgets/mensajes.dart';
import 'package:obligatorio_flutter/utilidades/validaciones.dart';
import 'package:sqflite/sqflite.dart';

class ModificarTipo extends StatefulWidget {
  const ModificarTipo({super.key});

  @override
  State<ModificarTipo> createState() => _ModificarTipoState();
}

class _ModificarTipoState extends State<ModificarTipo> {

  
final GlobalKey<FormState> _calveFormulario=GlobalKey<FormState>();

  late List<Tipo> _tipos;
  late Tipo _tipo;

  @override
  void didChangeDependencies() {
    _tipo = ModalRoute.of(context)?.settings.arguments as Tipo;
        
    DAOTipos().listarTipos().then((value) {
      _tipos=value;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const AppBarGenerica(titulo: 'Modificar Tipo',
      ),
      body: ContenedorImagen(
        child: Form(
          key: _calveFormulario,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ContenedorPersonalizado(
                child: TextFormField(
                  initialValue:_tipo.nombre,
                  decoration: const InputDecoration(
                    label: Text('Nombre'),
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red,width: 2)
                    ),
                  ),
                  validator: (value) => Validaciones.validarNombreTipo(value),
                  onSaved: (newValue){
                    _tipo.nombre = newValue!.trim();
                  },
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  if(_calveFormulario.currentState?.validate() ?? false){
                    _calveFormulario.currentState?.save();
                    Tipo? tipoEncontrado = compararNombreTipo(_tipo.nombre);
                    if(tipoEncontrado == null) {
                      _tipo = Tipo(nombre: _tipo.nombre, activo: true);                            
                      try {  
                        DAOTipos().modificarTipo(_tipo);
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/lista_tipos');
                        mostrarSnackBar(context, 'Tipo de propiedad modificado correctamente');  
                      } on DatabaseException {                            
                          Mensajes.mostrarAlertDialog(context,'El Nombre ${_tipo.nombre} ya existe.');                                            
                      }
                    } else {
                      if (tipoEncontrado.activo) {
                        Mensajes.mostrarAlertDialog(context, 'El tipo con ese nombre ya existe');
                        return;
                      }
                      else {
                        Mensajes.mostrarAlertDialog(context, 'Tipo de propiedad ya existe, pero no esta activo, si lo desea volver a activar debe darlo de alta'); 
                        return;
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

    for(Tipo t in _tipos) {
     if (t.nombre == tipo) {
      tipoEncontrado = t;
      
     }
    }   
    return tipoEncontrado ;
  }
}