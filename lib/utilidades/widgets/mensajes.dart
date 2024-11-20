import 'package:flutter/material.dart';

class Mensajes{

static  void mostrarAlertDialog(BuildContext context, String mensaje){

      showDialog(context: context,  
               builder: (context) => AlertDialog(
                title:const Text('¡Error!'),
                content:  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.dangerous_outlined),
                    const SizedBox(height:5),
                    Text(mensaje)
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: (){                     
                      Navigator.of(context).pop();
                    }, 
                    child: const Text('Aceptar'),
                    ),
                ],
            ),
      );   
     }

  static void mostrarSnackBar(BuildContext context, String mensaje){    
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
}