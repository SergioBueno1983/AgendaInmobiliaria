// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obligatorio_flutter/daos/dao_clientes.dart';
import 'package:obligatorio_flutter/daos/dao_propiedades.dart';
import 'package:obligatorio_flutter/daos/dao_tipos.dart';
import 'package:obligatorio_flutter/utilidades/widgets/app_bar_generica.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';
import 'package:obligatorio_flutter/utilidades/widgets/mensajes.dart';
import 'package:obligatorio_flutter/utilidades/validaciones.dart';
import 'package:obligatorio_flutter/utilidades/widgets/contenedor_personalizado.dart';
import 'package:sqflite/sqflite.dart';

class AgregarPropiedad extends StatefulWidget {
  const AgregarPropiedad({super.key});

  @override
  State<AgregarPropiedad> createState() => _AgregarPropiedadState();
}

class _AgregarPropiedadState extends State<AgregarPropiedad> {

  final GlobalKey<FormState>_calveFormulario=GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  List<Cliente> _clientes=[];
  List<Tipo> _tipos=[];
  Cliente? _cliente;
  Tipo? _tipo;

  late int _padron;
  late String _zona;
  late String _direccion;
  late double? _superficie;
  late double? _precio;
  late bool _alquila = false;
  late bool _vende = false;
  late bool _checkMarcado=false;


  @override
  void initState() {
    super.initState();
    _padron= 0;
    _zona='';
    _direccion='';
    _superficie=0;
    _precio=0;
    DAOClientes().listarClientes().then((clientes) {
      _clientes=clientes;
    });
    DAOTipos().listarTiposActivos().then((tipos) {
    setState(() {
      _tipos = tipos;
    });
    }); 
  _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const AppBarGenerica(titulo: 'Agregar Propiedad',),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
              key: _calveFormulario,
              child: Column(
                children: [
                  ContenedorPersonalizado(
                    child: TextFormField(
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        label: Text('Padron'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 2,),
                      ),
                      ),
                      validator: (value) => Validaciones.validarPadron(value),
                      onSaved:(newValue) {
                        _padron= int.parse(newValue!);
                      },
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ContenedorPersonalizado(
                    child: TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                        label: Text('Zona'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 2,),
                      ),
                      ),
                      validator:(value) => Validaciones.validarZona(value),
                      onSaved:(newValue) {
                        _zona= newValue!;
                      },
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ContenedorPersonalizado(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        label: Text('Direccion'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 2,),
                      ),
                      ),
                      validator: (value) => Validaciones.validarDireccion(value),
                      onSaved:(newValue) {
                        _direccion= newValue!;
                      },
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ContenedorPersonalizado(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Superficie'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 2,),
                      ),
                      ),
                      validator:(value) => Validaciones.validarSuperficie(value),
                      onSaved:(newValue) {
                        if (newValue != '') {
                          _superficie= double.parse(newValue!);
                        } else {
                          _superficie = null;
                        }                      },
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ContenedorPersonalizado(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Precio'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 2,),
                      ),
                      ),
                      validator:(value) => Validaciones.validarPrecio(value),
                      onSaved:(newValue) {
                        if(newValue!.isNotEmpty){
                          _precio= double.parse(newValue);
                        }else{
                        _precio= null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ContenedorPersonalizado(
                    child: CheckboxListTile(
                      title: const Text('Alquila'),
                      value: _alquila,
                      onChanged:(value) {
                        setState(() {
                          _alquila=value!;
                          _checkMarcado= _alquila || _vende;
                        });                    
                      },                
                    ),
                  ),
                  const SizedBox(height: 10,),
                   ContenedorPersonalizado(
                     child: CheckboxListTile(
                      title: const Text('Vende'),
                      value: _vende,
                      onChanged:(value) {
                        setState(() {
                          _vende=value!;
                          _checkMarcado= _alquila || _vende;
                        });                    
                      },                
                                         ),
                   ),
                   const SizedBox(height: 10,),
                  ContenedorPersonalizado(
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
                    ContenedorPersonalizado(
                      child: ListTile(
                        title: const Text('Tipo'),
                        onTap: (){
                                setState(() {
                                  mostrarTipos(context);
                                });
                              },
                        subtitle: _tipo != null ? Text('Nombre: ${_tipo!.nombre}') : const Text('Seleccione un Tipo.'),
                        trailing: const Icon(Icons.list_alt_outlined),
                            
                      ),
                    ),
                 ElevatedButton(
                    onPressed: () async {
                  if (_calveFormulario.currentState?.validate() ?? false) {
                    if (_checkMarcado) {                        
                      if (_tipo == null || _cliente == null) {
                        Mensajes.mostrarAlertDialog(context, 'Debe seleccionar un tipo y un cliente.');
                        return;
                      }
                      _calveFormulario.currentState?.save();
                      Propiedad nuevaPropiedad = Propiedad(
                        padron: _padron,
                        zona: _zona,
                        direccion: _direccion,
                        superficie: _superficie,
                        precio: _precio,
                        alquila: _alquila,
                        vende: _vende,
                        tipoId: _tipo!.id!,
                        clienteId: _cliente!.id!,
                      );
                      try{
                      await DAOPropiedades().agregarPropiedad(nuevaPropiedad);
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/lista_propiedades');
                      Mensajes.mostrarSnackBar(context, 'La propiedad se agregó correctamente');  
                      }on DatabaseException catch(e){
                        if(e.isUniqueConstraintError()){
                          Mensajes.mostrarAlertDialog(context, 'El padron ${nuevaPropiedad.padron} ya existe.');
                        }
            
                      }
                    } else {
                      Mensajes.mostrarAlertDialog(
                          context, 'Debe seleccionar al menos un tipo de oferta');
                    }
                  }
                },
                    child: const Icon(Icons.save)
                    
                  ),
                ],
              ),
            ),
          ),
                    ),
        ),
      ),
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
    void mostrarTipos(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.separated(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _tipo=_tipos[index];
                          Navigator.of(context).pop();
                        });
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(_tipos[index].nombre),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const Divider(height: 0),
                    itemCount: _tipos.length,
                  ),
        )
      )
    );
  }
}