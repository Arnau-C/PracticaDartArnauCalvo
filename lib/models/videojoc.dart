import 'package:practica_dart_arnau_calvo/models/enums.dart';

sealed class Videojoc<T> {
  final String nom;
  final String codi;
  final EstilJoc estil;
  final double preuCompra;
  final double preuLloguer;

  final Map<String, List<T>>
  highScores = {};

  Videojoc(
    this.nom,
    this.codi,
    this.estil,
    this.preuCompra,
    this.preuLloguer,
  );

  String mostrarHighScores();
}
