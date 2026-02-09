extension MailValidator on String {
  //Función para validar si un string es un email válido usando una expresión regular
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  //Función para validar si un string es una contraseña válida usando una expresión regular
  bool isValidPassword() {
    //La contraseña debe tener al menos 4 caracteres, al menos una letra y al menos un número
    final passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d).{4,}$',
    );
    return passwordRegex.hasMatch(this);
  }

  //Función para validar si un string es un nick válido usando una expresión regular
  bool isValidNick() {
    final nickRegex = RegExp(
      r'^[a-zA-Z0-9]{2,15}$',
    );
    return nickRegex.hasMatch(this);
  }
}
