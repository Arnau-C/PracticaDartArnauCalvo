import 'package:practica_dart_arnau_calvo/controllers/auth_controller.dart';
import 'package:practica_dart_arnau_calvo/models/app_state.dart';

class AppViewModel {
  //Constructor singleton private
  AppViewModel._internal();

  //Singleton instance
  static final AppViewModel _instance =
      AppViewModel._internal();

  //Factory constructor para acceder a la instancia singleton
  factory AppViewModel() {
    return _instance;
  }

  AppState _state = AppState.splash;

  final AuthController _authController =
      AuthController();

  void startApp() {
    print("Iniciando aplicación...");

    while (_state != AppState.exit) {
      switch (_state) {
        case AppState.splash:
          print("Carregant dades...");
          _state = AppState.login;
          break;
        case AppState.login:
          _state = _authController
              .gestionarInici();
          break;
        case AppState.menuUser:
          print(
            "Mostrant menú de usuario...",
          );
          // Aquí iría la lógica para mostrar el menú de usuario
          _state = AppState
              .exit; // Placeholder para salir después del menú
          break;
        default:
          _state = AppState.exit;
      }
    }
    print("Surt de l'aplicació.");
  }
}
