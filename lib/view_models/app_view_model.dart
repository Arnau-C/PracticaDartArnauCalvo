import 'package:practica_dart_arnau_calvo/controllers/auth_controller.dart';
import 'package:practica_dart_arnau_calvo/controllers/game_controller.dart';
import 'package:practica_dart_arnau_calvo/controllers/user_controller.dart';
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

  final UserController _userController =
      UserController();

  final GameController _gameController =
      GameController();

  void startApp() {
    print("Iniciando aplicación...");

    while (_state != AppState.exit) {
      switch (_state) {
        case AppState.splash:
          print("Carregant dades...");
          //Aquí iría la lógica para cargar datos iniciales

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
          _state = _userController
              .gestionarMenuUser();
          break;
        case AppState.play:
          print(
            "Mostrant menú de juego...",
          );
          _state = _gameController
              .gestionarMenuPartida();
          break;
        default:
          _state = AppState.exit;
      }
    }
    print("Surt de l'aplicació.");
  }
}
