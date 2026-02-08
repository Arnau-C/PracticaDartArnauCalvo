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

  void registrarPuntuacio(
    String mailUser,
    T puntuacio,
  ) {
    if (!highScores.containsKey(
      mailUser,
    )) {
      highScores[mailUser] = [];
    }
    highScores[mailUser]!.add(
      puntuacio,
    );
  }
}

// Joc basat en punts
class JocPunts extends Videojoc<int> {
  JocPunts(
    super.nom,
    super.codi,
    super.estil,
    super.preuCompra,
    super.preuLloguer,
  );

  //Metode per mostrar el ranking de punts
  @override
  String mostrarHighScores() {
    var allScores =
        <MapEntry<String, int>>[];
    highScores.forEach((mail, scores) {
      for (var p in scores) {
        allScores.add(
          MapEntry(mail, p),
        );
      }
    });

    //Ordenem de major a menor
    allScores.sort((a, b) {
      return b.value.compareTo(a.value);
    });

    //Preparem la sortida, el buffered serveix per anar afegint linies
    StringBuffer sb = StringBuffer(
      "\n--- RÀNQUING DE PUNTS ($nom) ---\n",
    );
    int count = 0;
    for (var entry in allScores.take(
      10,
    )) {
      count++;
      sb.writeln(
        "$count. ${entry.key}: ${entry.value} pts",
      );
    }
    return sb.toString();
  }
}

class JocTemps
    extends Videojoc<Duration> {
  JocTemps(
    super.nom,
    super.codi,
    super.estil,
    super.preuCompra,
    super.preuLloguer,
  );

  @override
  String mostrarHighScores() {
    var allScores =
        <MapEntry<String, Duration>>[];
    highScores.forEach((mail, scores) {
      for (var t in scores) {
        allScores.add(
          MapEntry(mail, t),
        );
      }
    });

    allScores.sort((a, b) {
      return a.value.compareTo(b.value);
    });

    StringBuffer sb = StringBuffer(
      "\n--- RÀNQUING SPEEDRUN ($nom) ---\n",
    );
    int count = 0;
    for (var entry in allScores.take(
      10,
    )) {
      count++;
      // Formateamos la duración a minutos:segundos
      String formatted =
          "${entry.value.inMinutes}:${entry.value.inSeconds.remainder(60).toString().padLeft(2, '0')}";
      sb.writeln(
        "$count. ${entry.key}: $formatted min",
      );
    }
    return sb.toString();
  }
}

class JocVictories
    extends Videojoc<String> {
  JocVictories(
    super.nom,
    super.codi,
    super.estil,
    super.preuCompra,
    super.preuLloguer,
  );

  @override
  String mostrarHighScores() {
    // Calculamos el % de victorias por usuario
    var userStats =
        <MapEntry<String, double>>[];

    highScores.forEach((
      user,
      resultados,
    ) {
      int wins = resultados
          .where((r) => r == 'V')
          .length;
      double winRate =
          resultados.isEmpty
          ? 0.0
          : (wins / resultados.length) *
                100;
      userStats.add(
        MapEntry(user, winRate),
      );
    });

    // Ordenamos por porcentaje de victoria descendente
    userStats.sort(
      (a, b) =>
          b.value.compareTo(a.value),
    );

    StringBuffer sb = StringBuffer(
      "\n--- RÀNQUING VICTORIES ($nom) ---\n",
    );
    int count = 0;
    for (var entry in userStats.take(
      10,
    )) {
      count++;
      sb.writeln(
        "$count. ${entry.key}: ${entry.value.toStringAsFixed(1)}% wins",
      );
    }
    return sb.toString();
  }
}

class JocCooperatiu
    extends Videojoc<int> {
  JocCooperatiu(
    super.nom,
    super.codi,
    super.estil,
    super.preuCompra,
    super.preuLloguer,
  );

  @override
  String mostrarHighScores() {
    var allScores =
        <MapEntry<String, int>>[];
    highScores.forEach((user, punts) {
      for (var p in punts) {
        allScores.add(
          MapEntry(user, p),
        );
      }
    });

    allScores.sort(
      (a, b) =>
          b.value.compareTo(a.value),
    );

    StringBuffer sb = StringBuffer(
      "\n--- RÀNQUING COOPERATIU ($nom) ---\n",
    );
    int count = 0;
    for (var entry in allScores.take(
      10,
    )) {
      count++;
      sb.writeln(
        "$count. Equip Líder ${entry.key}: ${entry.value} pts",
      );
    }
    return sb.toString();
  }
}
