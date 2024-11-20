import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obligatorio_flutter/daos/dao_clientes.dart';
import 'package:obligatorio_flutter/utilidades/widgets/app_bar_generica.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';
import 'package:obligatorio_flutter/utilidades/widgets/mensajes.dart';
import 'package:obligatorio_flutter/utilidades/validaciones.dart';

class ModificarCliente extends StatefulWidget {
  const ModificarCliente({super.key});

  @override
  State<ModificarCliente> createState() => _ModificarClienteState();
}

class _ModificarClienteState extends State<ModificarCliente> {

  final FocusNode _focusNode = FocusNode();

  final GlobalKey<FormState> _calveFormulario=GlobalKey<FormState>();

  late Cliente _cliente;

  @override
  void didChangeDependencies() {
    
    _cliente = ModalRoute.of(context)?.settings.arguments as Cliente;

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    });
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const AppBarGenerica(titulo: 'Modificar Cliente',
      ),
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
                Container(                
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,                     
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Nombre'),
                      
                    
                      border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red,width: 2)
                      ),
                    
                    ),
                    initialValue: _cliente.nombre,
                    validator:(value) => Validaciones.validarNombre(value), 
                    onSaved: (newValue){
                      _cliente.nombre = newValue!.trim();
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,                     
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      label: Text('Telefono'),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red,width: 2)
                      ),
                    ),
                    initialValue: _cliente.telefono,
                    validator:(value) => Validaciones.validarTelefono(value),
                    onSaved: (newValue){
                      _cliente.telefono = newValue!.trim();
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    if(_calveFormulario.currentState?.validate() ?? false){
                        _calveFormulario.currentState?.save();                  
                        DAOClientes().modificarCliente(_cliente);
                        Navigator.of(context).pop;
                        Navigator.of(context).pushReplacementNamed('/lista_cliente');
                        Mensajes.mostrarSnackBar(context, 'El cliente fue modificado correctamente');                    
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

}
