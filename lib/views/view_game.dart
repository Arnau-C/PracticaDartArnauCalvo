import 'package:practica_dart_arnau_calvo/models/videojoc.dart';

class ViewGame {
  void printGameMenu(Videojoc joc) {
    print("=== Menú del Joc ===");
    print(joc.getRepteDelDia());
    print("[H] Highscores");
    print("[G] Grup");
    print("[P] Puntuació");
    print("[E] Enrere");
    print("[T] Tancar aplicació");
  }
}
