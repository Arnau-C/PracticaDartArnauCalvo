import 'package:practica_dart_arnau_calvo/models/app_state.dart';
import 'package:practica_dart_arnau_calvo/models/llicencia.dart';
import 'package:practica_dart_arnau_calvo/models/user.dart';
import 'package:practica_dart_arnau_calvo/models/videojoc.dart';
import 'package:practica_dart_arnau_calvo/utils/utils.dart';
import 'package:practica_dart_arnau_calvo/views/view_game.dart';

class GameController {
  static final GameController
  _instance =
      GameController._internal();
  factory GameController() => _instance;
  GameController._internal();

  final ViewGame _viewGame = ViewGame();

  User? _jugadorActual;
  Llicencia? _llicenciaActual;

  void cargarPartida(
    User user,
    Llicencia llicencia,
  ) {
    _jugadorActual = user;
    _llicenciaActual = llicencia;
  }

  AppState gestionarMenuPartida() {
    // Seguridad: Si no hay datos cargados, volvemos atrás
    if (_jugadorActual == null ||
        _llicenciaActual == null) {
      return AppState.menuUser;
    }

    Videojoc joc =
        _llicenciaActual!.joc;

    // Pintar menú con el reto
    _viewGame.printGameMenu(joc);

    // Leer opción
    String opcio = Utils.readString(
      "Què vols fer?",
    ).toUpperCase();

    switch (opcio) {
      case 'H': // HighScores
        print(joc.mostrarHighScores());
        return AppState.play;

      case 'P': // Jugar / Puntuar
        _simularPartida(joc);
        return AppState.play;

      case 'E': // Salir
        print("Tancant el joc...");
        // Si es una demo, reducimos las horas restantes
        if (_llicenciaActual!
                .horesRestants >
            0) {
          _llicenciaActual!
              .horesRestants--;
          print(
            "Temps restant de prova: ${_llicenciaActual!.horesRestants}h",
          );
        }

        // Limpiamos sesión
        _jugadorActual = null;
        _llicenciaActual = null;
        return AppState
            .menuUser; // Volvemos a Vista 2

      case 'T':
        return AppState.exit;

      default:
        print("Opció no vàlida.");
        return AppState.play;
    }
  }

  void _simularPartida(Videojoc joc) {
    print(
      "\n--- JUGANT A LA PARTIDA ---",
    );
    print("Simulant joc...");

    // Juego de Puntos (int)
    if (joc is JocPunts) {
      int punts = Utils.readInt(
        "Puntuació final obtinguda",
      );
      joc.registrarPuntuacio(
        _jugadorActual!.mail,
        punts,
      );
      print(
        "Punts registrats al rànquing!",
      );
    }
    // Juego de Tiempo / Speedrun (Duration)
    else if (joc is JocTemps) {
      print(
        "Introdueix el temps en segons.",
      );
      int segons = Utils.readInt(
        "Segons trigats",
      );
      Duration temps = Duration(
        seconds: segons,
      );

      joc.registrarPuntuacio(
        _jugadorActual!.mail,
        temps,
      );
      print(
        "Temps registrat: ${temps.inMinutes} min ${temps.inSeconds % 60} s",
      );
    }
    // Juego de Victorias (bool)
    else if (joc is JocVictories) {
      String
      resultat = Utils.readString(
        "Has guanyat la partida? (S/N)",
      ).toUpperCase();

      bool haGuanyat = false;
      if (resultat == "S") {
        haGuanyat = true;
      }

      joc.registrarPuntuacio(
        _jugadorActual!.mail,
        haGuanyat,
      );

      if (haGuanyat) {
        print("Victòria registrada!");
      } else {
        print(
          "Has registrat una derrota. Més sort la pròxima!",
        );
      }
    }
    // Juego Cooperativo (int)
    else if (joc is JocCooperatiu) {
      int punts = Utils.readInt(
        "La teva aportació de punts a l'equip",
      );
      joc.registrarPuntuacio(
        _jugadorActual!.mail,
        punts,
      );
      print(
        "Punts d'equip registrats!",
      );
    }
  }
}
