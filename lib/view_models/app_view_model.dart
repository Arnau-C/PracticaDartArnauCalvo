import 'dart:io';

import 'package:practica_dart_arnau_calvo/views/view_login.dart';

class AppViewModel {
  final ViewLogin _viewLogin =
      ViewLogin();
  bool _isRunning = true;

  void start() {
    while (_isRunning) {
      _viewLogin.printMenuLogin();
      String? option = stdin
          .readLineSync()
          ?.toUpperCase();

      switch (option) {
        case 'E':
          print(
            "Has seleccionat 'Entrar'.",
          );
          // Aquí aniria la lògica per entrar
          break;
        case 'R':
          print(
            "Has seleccionat 'Registrar-se'.",
          );
          // Aquí aniria la lògica per registrar-se
          break;
        case 'T':
          print("Tancant aplicació...");
          _isRunning = false;
          break;
        default:
          print(
            "Opció no vàlida. Si us plau, intenta-ho de nou",
          );
      }
    }
  }

  void menuUser() {
    bool isUserMenuRunning = true;
  }
}
