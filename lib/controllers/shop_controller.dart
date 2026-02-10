import 'package:practica_dart_arnau_calvo/models/enums.dart';
import 'package:practica_dart_arnau_calvo/models/videojoc.dart';

class ShopController {
  static final ShopController
  _instance =
      ShopController._internal();
  factory ShopController() => _instance;

  final List<Videojoc> _jocs = [];

  ShopController._internal() {
    _carregarDades();
  }

  // Método privado para cargar datos iniciales
  void _carregarDades() {
    _jocs.addAll([
      JocPunts(
        "Super Dart Bros",
        "mario",
        EstilJoc.plataformes,
        50.0,
        5.0,
      ),
      JocVictories(
        "Call of Code",
        "cod",
        EstilJoc.shooter,
        60.0,
        10.0,
      ),
      JocTemps(
        "Sonic Loop",
        "sonic",
        EstilJoc.plataformes,
        40.0,
        4.0,
      ),
      JocCooperatiu(
        "Among Dart",
        "among",
        EstilJoc.simulacio,
        15.0,
        2.0,
      ),
      JocVictories(
        "Poker Stars",
        "poker",
        EstilJoc.cartes,
        20.0,
        2.0,
      ),
    ]);
  }

  // Método para buscar un juego por su código[J/C]
  Videojoc? buscarJoc(String codi) {
    try {
      return _jocs.firstWhere(
        (j) =>
            j.codi.toLowerCase() ==
            codi.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Método para listar juegos por estilo [B]
  void llistarJocsPerEstil(
    EstilJoc? estil,
  ) {
    print(
      "\n--- JOCS DISPONIBLES (${estil?.name ?? 'TOTS'}) ---",
    );

    var llistaFiltrada = estil == null
        ? _jocs
        : _jocs.where((j) {
            return j.estil == estil;
          }).toList();

    if (llistaFiltrada.isEmpty) {
      print(
        "No hi ha jocs d'aquest estil.",
      );
    } else {
      for (var joc in llistaFiltrada) {
        print(
          "- [${joc.codi}] ${joc.nom} (Compra: ${joc.preuCompra}€ / Lloguer: ${joc.preuLloguer}€)",
        );
      }
    }
  }
}
