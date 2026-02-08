import 'dart:math';

import 'package:practica_dart_arnau_calvo/models/enums.dart';

class Llicencia {
  final String id;
  final TipusLlicencia tipus;
  final String jocCodi;
  int canvisPropietariRestants;
  int horesRestants;

  //constructor principal
  Llicencia({
    required this.id,
    required this.tipus,
    required this.jocCodi,
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
    required String jocCodi,
  }) {
    return Llicencia(
      id: _generarId(),
      tipus: TipusLlicencia.compra,
      jocCodi: jocCodi,
      canvisPropietariRestants: 3,
      horesRestants: -1,
    );
  }

  //Lloguer: 0 canvis de propietari restants, horesRestants = -1 (infinites)
  factory Llicencia.lloguer({
    required String jocCodi,
  }) {
    return Llicencia(
      id: _generarId(),
      tipus: TipusLlicencia.lloguer,
      jocCodi: jocCodi,
      canvisPropietariRestants: 0,
      horesRestants: -1,
    );
  }

  //Prova: 0 canvis de propietari restants, horesRestants = 3
  factory Llicencia.prova({
    required String jocCodi,
  }) {
    return Llicencia(
      id: _generarId(),
      tipus: TipusLlicencia.prova,
      jocCodi: jocCodi,
      canvisPropietariRestants: 0,
      horesRestants: 3,
    );
  }

  @override
  String toString() {
    return "Llicencia $tipus ($id) - Joc: $jocCodi - Hores: $horesRestants";
  }
}
