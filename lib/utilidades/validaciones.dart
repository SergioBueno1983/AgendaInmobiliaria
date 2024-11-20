class Validaciones{

  static validarNombre(String? value){
    if (value == null || value.isEmpty) {
      return 'El Nombre no puede quedar vacio';
    }
    if(value.length > 50){
      return 'El Nombre no puede tener mas de 50 caracteres';
    }
    return null;
  }

  static validarTelefono(String? value){
    if (value == null || value.isEmpty) {
      return 'El Telefono no puede quedar vacio';
    }
    if(value.length > 50){
      return 'El Telefono no puede tener mas de 50 caracteres';
    }
    return null;
  }

  static validarPadron(String? value){
    if (value == null || value.isEmpty) {
      return 'El padron no puede quedar vacio';
    }
    try {
      int padron = int.parse(value);
      if (padron < 0) {
        return 'El padron tiene que ser positivo';
      }
    } on FormatException {
      return 'El padron tiene que ser un numero entero';
    }
    return null;
  }                
  
  static validarZona(String? value) {
    if (value == null || value.isEmpty) {
      return 'La Zona no puede quedar vacio';
    }
    if (value.length > 50) {
      return 'La Zona no puede tener mas de 50 caracteres';
    }
    return null;
  }

  static validarDireccion(String? value) {
    if (value == null || value.isEmpty) {
      return 'La Direccion no puede quedar vacio';
    }
    if (value.length > 100) {
      return 'La Direccion no puede tener mas de 100 caracteres';
    }
    return null;
  }

  static validarSuperficie(String? value) {
    if (value != null && value.isNotEmpty) {
    try {
      double superficie = double.parse(value);
      if (superficie < 0 || superficie >double.maxFinite) {
        return 'La Superficie tiene que ser un numero positivo valido';
      }
    } on FormatException {
      return 'La Superficie no es valida "xxx.xx" ';
    }   
    }
     return null;
  }

  static validarPrecio(String? value) {
    if (value != null && value.isNotEmpty) {    
    try {
      double precio = double.parse(value);
      if (precio < 0 || precio >double.maxFinite) {
        return 'El Precio tiene que ser un numero positivo valido';
      }
    } on FormatException {
      return 'El Precio no es valido "xxx.xx"';
    }
    }
    return null;
  }

  static validarNombreTipo(String? value){
    if (value == null || value.isEmpty) {
      return 'El Nombre del tipo no puede quedar vacio';
    }
    if (value.length > 50) {
      return 'El Nombre del tipo no puede tener mas de 50 caracteres';
    }
    return null;
  }

}