import 'dart:math';

import 'package:practica_dart_arnau_calvo/models/enums.dart';
import 'package:practica_dart_arnau_calvo/models/videojoc.dart';

class Llicencia {
  final String id;
  final TipusLlicencia tipus;
  final Videojoc joc;
  int canvisPropietariRestants;
  int horesRestants;

  //constructor principal
  Llicencia._({
    required this.id,
    required this.tipus,
    required this.joc,
    required this.canvisPropietariRestants,
    required this.horesRestants,
  });

  //se lo he pedido a la ia
  static String _generarId() {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        10,
        (_) => chars.codeUnitAt(
          rnd.nextInt(chars.length),
        ),
      ),
    );
  }

  //Compra: 3 canvis de propietari restants, horesRestants = -1 (infinites)
  factory Llicencia.compra({
    required Videojoc joc,
  }) {
    return Llicencia._(
      id: _generarId(),
      tipus: TipusLlicencia.compra,
      joc: joc,
      canvisPropietariRestants: 3,
      horesRestants: -1,
    );
  }

  //Lloguer: 0 canvis de propietari restants, horesRestants = -1 (infinites)
  factory Llicencia.lloguer({
    required Videojoc joc,
  }) {
    return Llicencia._(
      id: _generarId(),
      tipus: TipusLlicencia.lloguer,
      joc: joc,
      canvisPropietariRestants: 0,
      horesRestants: -1,
    );
  }

  //Prova: 0 canvis de propietari restants, horesRestants = 3
  factory Llicencia.prova({
    required Videojoc joc,
  }) {
    return Llicencia._(
      id: _generarId(),
      tipus: TipusLlicencia.prova,
      joc: joc,
      canvisPropietariRestants: 0,
      horesRestants: 3,
    );
  }

  @override
  String toString() {
    return "Llicencia $tipus ($id) - Joc: $joc - Hores: $horesRestants";
  }

  // Método para transferir la licencia a otro usuario (solo para compra)
  bool transferir() {
    if (canvisPropietariRestants > 0) {
      canvisPropietariRestants--;
      return true;
    }
    return false;
  }
}
