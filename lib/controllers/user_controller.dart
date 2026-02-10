import 'package:practica_dart_arnau_calvo/controllers/auth_controller.dart';
import 'package:practica_dart_arnau_calvo/controllers/game_controller.dart';
import 'package:practica_dart_arnau_calvo/controllers/shop_controller.dart';
import 'package:practica_dart_arnau_calvo/exceptions/game_exceptions.dart';
import 'package:practica_dart_arnau_calvo/models/app_state.dart';
import 'package:practica_dart_arnau_calvo/models/enums.dart';
import 'package:practica_dart_arnau_calvo/models/llicencia.dart';
import 'package:practica_dart_arnau_calvo/models/user.dart';
import 'package:practica_dart_arnau_calvo/models/videojoc.dart';
import 'package:practica_dart_arnau_calvo/utils/utils.dart';
import 'package:practica_dart_arnau_calvo/views/view_user.dart';

class UserController {
  static final UserController
  _instance =
      UserController._internal();
  factory UserController() {
    return _instance;
  }
  UserController._internal();

  final ViewUser _viewUser = ViewUser();
  final AuthController _authController =
      AuthController();
  final ShopController _shopController =
      ShopController();
  final GameController _gameController =
      GameController();

  AppState gestionarMenuUser() {
    final user =
        _authController.currentUser;
    if (user == null) {
      return AppState.login;
    }

    _viewUser.printMenuUser();

    String opcio = Utils.readString(
      "Selecciona una opció: ",
    ).toUpperCase();

    switch (opcio) {
      case "J":
        print(
          "Has seleccionado Jugar.",
        );
        // Listar mis juegos
        if (user.llicencies.isEmpty) {
          print(
            "No tens cap joc comprat o llogat.",
          );
          print(
            "Ves a la Botiga [B] per aconseguir-ne un.",
          );
          return AppState.menuUser;
        }

        print("La teva biblioteca:");
        for (var l in user.llicencies) {
          print(
            "- [${l.joc.codi}] ${l.joc.nom} (${l.tipus.name})",
          );
        }

        // Pedir código
        String codi = Utils.readString(
          "Escriu el codi del joc",
        );

        // Buscar licencia válida
        try {
          Llicencia
          llicenciaTriada = user
              .llicencies
              .firstWhere((l) {
                return l.joc.codi
                        .toLowerCase() ==
                    codi.toLowerCase();
              });

          // Validar si la licencia ha caducado (Solo para demos)
          if (llicenciaTriada
                  .horesRestants ==
              0) {
            print(
              "El temps de prova d'aquest joc s'ha esgotat.",
            );
            return AppState.menuUser;
          }

          // CARGAR LA PARTIDA Y CAMBIAR DE ESTADO
          _gameController.cargarPartida(
            user,
            llicenciaTriada,
          );
          return AppState
              .play; // <--- ¡AQUÍ CAMBIAMOS A VISTA 3!
        } catch (e) {
          print(
            "No tens cap llicència vàlida per al codi '$codi'.",
          );
          return AppState.menuUser;
        }

      case "B":
        _mostrarBotigaFiltrada();
        return AppState.menuUser;

      case "C":
        _adquirirLlicencia(
          user,
          TipusLlicencia.compra,
        );
        return AppState.menuUser;

      case "L":
        _adquirirLlicencia(
          user,
          TipusLlicencia.lloguer,
        );
        return AppState.menuUser;

      case "P":
        _adquirirLlicencia(
          user,
          TipusLlicencia.prova,
        );
        return AppState.menuUser;

      case "D":
        _donarJoc(user);
        return AppState.menuUser;

      case "A":
        print(
          "\n--- ELS MEUS AMICS ---",
        );
        if (user.amics.isEmpty) {
          print(
            "No tens amics afegits.",
          );
        } else {
          user.amics.forEach(
            (amic) => print("- $amic"),
          );
        }
        return AppState.menuUser;

      case "F":
        print(
          "Has seleccionado Fer nou amic.",
        );
        print(
          "Has seleccionado Fer nou amic.",
        );
        String emailAmic =
            Utils.readString(
              "Email del nou amic",
            ).trim().toLowerCase();

        // No puedes ser amigo de ti mismo
        if (emailAmic ==
            user.mail.toLowerCase()) {
          print(
            "No pots afegir-te a tu mateix com a amic.",
          );
          return AppState.menuUser;
        }

        // Comprobar si ya es amigo
        if (user.amics.contains(
          emailAmic,
        )) {
          print(
            "Aquest usuari ja és a la teva llista d'amics.",
          );
          return AppState.menuUser;
        }

        // ¿Existe el usuario en la App?
        User? usuariTrobado =
            _authController
                .buscarUsuariPerEmail(
                  emailAmic,
                );

        if (usuariTrobado != null) {
          // Si existe, lo añadimos
          user.amics.add(emailAmic);
          print(
            "Amic afegit correctament: ${usuariTrobado.nick} ($emailAmic)",
          );
        } else {
          print(
            "Error: No existeix cap usuari registrat amb l'email '$emailAmic'.",
          );
        }
        return AppState.menuUser;

      case "E":
        print("Tancant sessió...");
        _authController.logout();
        return AppState.login;

      case "T":
        print("Fins aviat!");
        return AppState.exit;

      default:
        print("Opció no vàlida.");
        return AppState.menuUser;
    }
  }

  void _mostrarBotigaFiltrada() {
    print("\n--- FILTRE PER ESTIL ---");
    print("1. Shooter");
    print("2. Plataformes");
    print("3. Cartes");
    print("4. Simulació");
    print(
      "0. TOTS (Veure tot el catàleg)",
    ); // Opción explícita

    String op = Utils.readString(
      "Tria una opció",
    );
    EstilJoc? estilSeleccionat;

    switch (op) {
      case '1':
        estilSeleccionat =
            EstilJoc.shooter;
        break;
      case '2':
        estilSeleccionat =
            EstilJoc.plataformes;
        break;
      case '3':
        estilSeleccionat =
            EstilJoc.cartes;
        break;
      case '4':
        estilSeleccionat =
            EstilJoc.simulacio;
        break;
      case '0':
        estilSeleccionat =
            null; // null significa "Tots" en el ShopController
        break;
      default:
        print(
          "⚠️ Opció no reconeguda. Es mostraran tots els jocs per defecte.",
        );
        estilSeleccionat = null;
    }

    // Llamamos al controlador con el estilo (o null si son todos)
    _shopController.llistarJocsPerEstil(
      estilSeleccionat,
    );
  }

  // Lógica para opciones [C], [L], [P]
  void _adquirirLlicencia(
    var user,
    TipusLlicencia tipus,
  ) {
    try {
      String codi = Utils.readString(
        "Codi del joc",
      );
      Videojoc? joc = _shopController
          .buscarJoc(codi);

      if (joc != null) {
        Llicencia novaLlicencia;

        if (tipus ==
            TipusLlicencia.compra) {
          novaLlicencia =
              Llicencia.compra(
                joc: joc,
              ); // Usamos el factory
          print(
            ">> Compra realitzada: ${joc.nom} (${joc.preuCompra}€)",
          );
        } else if (tipus ==
            TipusLlicencia.lloguer) {
          novaLlicencia =
              Llicencia.lloguer(
                joc: joc,
              );
          print(
            ">> Lloguer realitzat: ${joc.nom}",
          );
        } else {
          novaLlicencia =
              Llicencia.prova(joc: joc);
          print(
            ">> Demo activada: ${joc.nom}",
          );
        }

        // Añadimos a la biblioteca del usuario
        user.llicencies.add(
          novaLlicencia,
        );
      } else {
        throw ValidationException(
          "No s'ha trobat cap joc amb el codi '$codi'.",
        );
      }
    } on GameException catch (e) {
      print(e.toString());
    }
  }

  void _donarJoc(User user) {
    print(
      "\n--- DONAR JOC A UN AMIC ---",
    );

    // Pedir código del juego a regalar
    String codiJoc = Utils.readString(
      "Codi del joc que vols regalar",
    );

    // Buscar si el usuario activo tiene la licencia
    Llicencia? llicenciaADonar;
    try {
      llicenciaADonar = user.llicencies
          .firstWhere((l) {
            return l.joc.codi
                    .toLowerCase() ==
                codiJoc.toLowerCase();
          });
    } catch (e) {
      print(
        "No tens cap llicència per al joc '$codiJoc'.",
      );
      return;
    }

    if (llicenciaADonar
            .canvisPropietariRestants <=
        0) {
      print(
        "Aquesta llicència no es pot transferir (0 canvis restants).",
      );
      return;
    }

    // Pedir y validar Amigo
    String emailAmic = Utils.readString(
      "Email del teu amic",
    ).trim().toLowerCase();

    if (!user.amics.contains(
      emailAmic,
    )) {
      print(
        "Aquest usuari no està a la teva llista d'amics.",
      );
      return;
    }

    // Obtener el objeto usuario del amigo
    User? amicUser = _authController
        .buscarUsuariPerEmail(
          emailAmic,
        );
    if (amicUser == null) {
      print(
        "Error tècnic: L'amic està a la llista però no existeix al sistema.",
      );
      return;
    }

    // VALIDACIÓN NUEVA: ¿El amigo YA tiene este juego?
    // Recorremos las licencias del amigo buscando el mismo código de juego
    bool jaTeElJoc = amicUser.llicencies
        .any((l) {
          return l.joc.codi ==
              llicenciaADonar!.joc.codi;
        });

    if (jaTeElJoc) {
      print(
        "Operació cancel·lada: ${amicUser.nick} ja té el joc '${llicenciaADonar.joc.nom}'.",
      );
      return;
    }

    // --- EJECUTAR TRANSFERENCIA ---
    // Usamos el método transferir() que baja el contador
    if (llicenciaADonar.transferir()) {
      // Borrar de mi inventario
      user.llicencies.remove(
        llicenciaADonar,
      );

      // Añadir al inventario del amigo
      amicUser.llicencies.add(
        llicenciaADonar,
      );

      print(
        "Èxit! Has regalat '${llicenciaADonar.joc.nom}' a ${amicUser.nick}.",
      );
      print(
        "   Canvis de propietari restants: ${llicenciaADonar.canvisPropietariRestants}",
      );
    } else {
      print(
        "Error inesperat al transferir la llicència.",
      );
    }
  }
}
