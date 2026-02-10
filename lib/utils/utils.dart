import 'dart:io';

import 'package:practica_dart_arnau_calvo/exceptions/game_exceptions.dart';

class Utils {
  //Función para leer un string desde la consola
  static String readString(
    String message,
  ) {
    while (true) {
      try {
        stdout.write("$message: ");

        //Lee la entrada del usuario y la trimmea osea quita espacios al principio y al final, si es null devuelve una cadena vacía
        String? input =
            stdin
                .readLineSync()
                ?.trim() ??
            "";
        if (input.isEmpty) {
          //Si el input es vacío, lanza una excepción de validación personalizada
          throw ValidationException(
            "Aquest camp no pot estar buit",
          );
        }

        return input;
      } catch (e) {
        //Si se lanza una excepción, la imprime y vuelve a pedir el input, usamos el toString para que se imprima el mensaje personalizado de la excepción
        print(e.toString());
      }
    }
  }

  static int readInt(String message) {
    while (true) {
      stdout.write("$message: ");
      String? input = stdin
          .readLineSync();

      if (input != null) {
        int? result = int.tryParse(
          input,
        );
        if (result != null) {
          return result;
        }
      }
      print(
        "Error: Has d'introduir un número enter.",
      );
    }
  }
}
