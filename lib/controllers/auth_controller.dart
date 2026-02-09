import 'package:practica_dart_arnau_calvo/exceptions/game_exceptions.dart';
import 'package:practica_dart_arnau_calvo/models/app_state.dart';
import 'package:practica_dart_arnau_calvo/models/user.dart';
import 'package:practica_dart_arnau_calvo/utils/extensions.dart';
import 'package:practica_dart_arnau_calvo/utils/utils.dart';
import 'package:practica_dart_arnau_calvo/views/view_login.dart';

class AuthController {
  static final AuthController
  _instance =
      AuthController._internal();
  factory AuthController() {
    return _instance;
  }
  AuthController._internal();

  final List<User> _users = [];

  User? _currentUser;

  //getters

  //Devuelve una lista inmutable de usuarios registrados
  List<User> get users {
    return List.unmodifiable(_users);
  }

  User? get currentUser {
    return _currentUser;
  }

  //Instancia de la vista de login para mostrar menu
  final ViewLogin _viewLogin =
      ViewLogin();

  AppState gestionarInici() {
    _viewLogin.printMenuLogin();

    String option = Utils.readString(
      "Selecciona una opción: ",
    ).toUpperCase();

    switch (option) {
      case "E":
        bool loggedIn = _login();
        if (loggedIn) {
          print("login ok");
          return AppState.menuUser;
        }
        return AppState.login;
      case "R":
        _register();
        return AppState.login;
      case "T":
        return AppState.exit;
      default:
        print(
          "Opció no vàlida, intenta-ho de nou.",
        );
        return AppState.login;
    }
  }

  //Función para registrar un nuevo usuario, pide email, nick y contraseña, valida los datos y los guarda en la lista de usuarios registrados, si hay algún error en el proceso se lanza una excepción personalizada y se muestra el mensaje de error
  void _register() {
    print(
      "\n--- REGISTRE NOU USUARI ---",
    );

    try {
      //Pedimos el email al usuario, usamos la función readString para leer el input y validarlo, si el input es vacío o no es un email válido o ya está registrado, se lanzará una excepción de validación personalizada y se volverá a pedir el input
      String mail = Utils.readString(
        "Introdueix el teu email: ",
      );

      //Validamos el email usando la función de extensión isValidEmail, si no es válido lanzamos una excepción de validación personalizada
      if (!mail.isValidEmail()) {
        throw ValidationException(
          "L'adreça de correu no té un format correcte. Assegura't d'incloure l'@ i un domini vàlid (com .com o .es).",
        );
      }

      //Validamos que el email no esté registrado ya, si lo está lanzamos una excepción de validación personalizada
      if (_users.any((user) {
        return user.mail == mail;
      })) {
        throw ValidationException(
          "Aquest email ja està registrat",
        );
      }

      String nick = Utils.readString(
        "Introdueix el teu nick: ",
      );

      if (!nick.isValidNick()) {
        throw ValidationException(
          "El Nick només pot contenir lletres i números, sense espais ni símbols, i ha de tenir entre 2 i 15 caràcters.",
        );
      }

      String
      password = Utils.readString(
        "Introdueix la teva contrasenya: ",
      );

      if (!password.isValidPassword()) {
        throw ValidationException(
          "La contrasenya no és segura. Ha de tenir mínim 8 caràcters i incloure majúscules, minúscules, números i un símbol (ex:@, #).",
        );
      }

      _users.add(
        User(
          mail: mail,
          nick: nick,
          password: password,
        ),
      );

      print(
        "Usuari registrat correctament!",
      );
    } on GameException catch (e) {
      print(e.toString());
    }
  }

  //Función para iniciar sesión, pide email y contraseña, busca el usuario en la lista de usuarios registrados, si no lo encuentra o la contraseña es incorrecta se lanza una excepción de autenticación personalizada y se muestra el mensaje de error, si el login es correcto se guarda el usuario en la variable _currentUser y se muestra un mensaje de bienvenida
  bool _login() {
    print("\n--- INICIAR SESSIÓ ---");
    try {
      String mail = Utils.readString(
        "Introdueix el teu email: ",
      );
      String
      password = Utils.readString(
        "Introdueix la teva contrasenya: ",
      );

      //Buscamos el usuario por su email, si no lo encontramos lanzamos una excepción de autenticación personalizada
      final user = _users.firstWhere(
        (u) {
          return u.mail == mail;
        },
        orElse: () => throw AuthException(
          "No s'ha trobat cap usuari amb aquest email",
        ),
      );

      if (user.password != password) {
        throw AuthException(
          "Contrasenya incorrecta",
        );
      }

      _currentUser = user;
      print(
        "Sessió iniciada correctament! Benvingut, ${user.nick}!",
      );
      return true;
    } on GameException catch (e) {
      print(e.toString());
      return false;
    }
  }
}
