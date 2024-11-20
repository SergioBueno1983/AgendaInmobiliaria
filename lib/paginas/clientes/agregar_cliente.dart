import 'package:flutter/material.dart';
import 'package:obligatorio_flutter/daos/dao_clientes.dart';
import 'package:obligatorio_flutter/entidades/cliente.dart';
import 'package:obligatorio_flutter/utilidades/widgets/app_bar_generica.dart';
import 'package:obligatorio_flutter/utilidades/widgets/contenedor_personalizado.dart';
import 'package:obligatorio_flutter/utilidades/widgets/mensajes.dart';
import 'package:obligatorio_flutter/utilidades/validaciones.dart';

class AgregarCliente extends StatefulWidget {
  const AgregarCliente({super.key});

  @override
  State<AgregarCliente> createState() => _AgregarClienteState();
}

class _AgregarClienteState extends State<AgregarCliente> {


  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _calveFormulario = GlobalKey<FormState>();
  
  String? _nombre;
  String? _telefono;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarGenerica(
        titulo: 'Agregar Cliente',
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
                  ContenedorPersonalizado(
                    child: TextFormField(
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        label: Text('Nombre'),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        )),
                      ),
                      validator: (value) => Validaciones.validarNombre(value),
                      onSaved: (newValue) => _nombre =newValue!.trim(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ContenedorPersonalizado(
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        label: Text('Telefono'),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2)),
                      ),
                      validator: (value) => Validaciones.validarTelefono(value),
                      onSaved: (newValue) => _telefono = newValue!.trim(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_calveFormulario.currentState?.validate() ?? false) {
                        _calveFormulario.currentState?.save();
                        DAOClientes().agregarCliente(Cliente(nombre: _nombre!, telefono: _telefono!));
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/lista_clientes');
                        Mensajes.mostrarSnackBar(context, 'El cliente fue agregado correctamente');
                      }
                    },
                    child: const Icon(Icons.save),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
