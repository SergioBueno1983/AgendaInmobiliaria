import 'package:flutter/material.dart';
import 'package:obligatorio_flutter/daos/dao_clientes.dart';
import 'package:obligatorio_flutter/daos/dao_propiedades.dart';
import 'package:obligatorio_flutter/daos/dao_tipos.dart';
import 'package:obligatorio_flutter/utilidades/widgets/app_bar_generica.dart';
import 'package:obligatorio_flutter/utilidades/widgets/contenedor_imagen.dart';
import 'package:obligatorio_flutter/utilidades/widgets/contenedor_personalizado.dart';
import 'package:obligatorio_flutter/utilidades/rutas/index_entidades.dart';
import 'package:obligatorio_flutter/utilidades/widgets/mensajes.dart';
import 'package:obligatorio_flutter/utilidades/validaciones.dart';

class ModificarPropiedad extends StatefulWidget {
  const ModificarPropiedad({super.key});

  @override
  State<ModificarPropiedad> createState() => _ModificarPropiedadState();
}

class _ModificarPropiedadState extends State<ModificarPropiedad>{
 
  final GlobalKey<FormState>_calveFormulario=GlobalKey<FormState>();
  late Propiedad _propiedad;  
  TextStyle titulo= const TextStyle(fontSize: 20, color: Colors.black);

  List<Cliente> _clientes=[];
  List<Tipo> _tipos=[];
  List<Tipo> _tiposTodos=[];
  
  
  Cliente? _cliente;
  Tipo? _tipo;


  @override
    void didChangeDependencies() async {
      
      _propiedad = ModalRoute.of(context)!.settings.arguments as Propiedad;
      await DAOClientes().listarClientes().then((clientes) {
        _clientes=clientes;
      });
      DAOTipos().listarTiposActivos().then((tipos) {
      setState(() {
        _tipos = tipos;
      });
      }); 
      await DAOTipos().listarTipos().then((tipos) {
      setState(() {
        _tiposTodos = tipos;
      });
      });

      for (Cliente c in _clientes) {
        if (c.id == _propiedad.clienteId) _cliente = c;      
      }
      for (Tipo t in _tiposTodos) {
        if (t.id == _propiedad.tipoId) _tipo = t;      
      }
      super.didChangeDependencies();
    }
    


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const AppBarGenerica(titulo: 'Modificar Propiedad',),
      body: ContenedorImagen(
            child: Form(
            key: _calveFormulario,
            child: Column(
              children: [          
                Text('Padron: ${_propiedad.padron}', style: const TextStyle(fontSize: 25),),
                const SizedBox(height: 10,),
                ContenedorPersonalizado(
                  child: TextFormField(
                    initialValue: _propiedad.zona,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2)
                      ),
                    label: Text('Zona', style: titulo,),
                    
                    ),
                    validator:(value) => Validaciones.validarZona(value),
                    onSaved:(newValue) {
                      _propiedad.zona = newValue!;
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                ContenedorPersonalizado(
                  child: TextFormField(
                    initialValue: _propiedad.direccion,
                    decoration:  InputDecoration(
            
                      border:const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2 )),
                      label: Text('Direccion', style: titulo),
                    ),
                    validator: (value) => Validaciones.validarDireccion(value),
                    onSaved:(newValue) {
                      _propiedad.direccion= newValue!;
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                ContenedorPersonalizado(
                  child: TextFormField(
                    initialValue:_propiedad.superficie == null ? '' : _propiedad.superficie.toString(),
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                      border:const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2 )),                          
                      label: Text('Superficie' , style: titulo),
                    ),
                    validator:(value) => Validaciones.validarSuperficie(value),
                    onSaved:(newValue) {
                      if (newValue != '') {
                        _propiedad.superficie= double.parse(newValue!);
                      } else {
                        _propiedad.superficie = null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                ContenedorPersonalizado(
                  child: TextFormField(
                    initialValue: _propiedad.precio == null ? '': _propiedad.precio.toString(),
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                      border:const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2 )),
                      label: Text('Precio' , style: titulo),
                    ),
                    validator:(value) => Validaciones.validarPrecio(value),
                    onSaved:(newValue) {
                      if(newValue!.isNotEmpty){
                        _propiedad.precio= double.parse(newValue);
                      }else{
                        _propiedad.precio= null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                ContenedorPersonalizado(
                  child: CheckboxListTile(
                    title:  Text('Alquila', style: titulo),
                    value: _propiedad.alquila,
                    onChanged:(value) {
                      setState(() {
                        _propiedad.alquila=value!;
                      });                    
                    },                
                  ),
                ),
                const SizedBox(height: 10,),
                 ContenedorPersonalizado(
                  child: CheckboxListTile(
                    title:  Text('Vende' , style: titulo),
                    value: _propiedad.vende,
                    onChanged:(value) {
                      setState(() {
                        _propiedad.vende=value!;
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
                    subtitle:Text(_cliente?.nombre ?? ''),
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
                    subtitle: Text(_tipo?.nombre ?? ''),                    
                    trailing: const Icon(Icons.list_alt_outlined),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    if (_calveFormulario.currentState?.validate() ?? false){
                      if (_propiedad.alquila! || _propiedad.vende!) {
                        _calveFormulario.currentState?.save();
                        _propiedad.tipoId = _tipo!.id!;
                        _propiedad.clienteId = _cliente!.id!;
                        DAOPropiedades().modificarPropiedad(_propiedad);
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/lista_propiedades');
                        Mensajes.mostrarSnackBar(context, 'La propiedad se Modifico correctamente ');
                      } else {
                        Mensajes.mostrarAlertDialog(context, 'Debe seleccionar al menos un tipo de oferta');
                      }
                    }
                  },
                  child: const Icon(Icons.save)
                ),
              ],
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
            itemBuilder: (context, index) => 
            GestureDetector(
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
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemCount: _tipos.length,
          ),
        )
      )
    );
  }

}