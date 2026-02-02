import 'package:practica_dart_arnau_calvo/models/llicencia.dart';

class User {
  final String mail;
  final String nick;
  final String password;
  final DateTime dataCreacio;
  final List<String> amics = [];
  final List<Llicencia> llicencies = [];

  User({
    required this.mail,
    required this.nick,
    required this.password,
  }) : dataCreacio = DateTime.now();

  @override
  String toString() {
    return "$nick ($mail) - Membre des de: ${dataCreacio.toIso8601String().split('T')[0]}";
  }
}
