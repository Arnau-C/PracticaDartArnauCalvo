class GameException
    implements Exception {
  final String message;
  GameException(this.message);

  @override
  String toString() {
    return "⚠️ $message";
  }
}

class AuthException
    extends GameException {
  AuthException(String message)
    : super(
        "Error d'autenticació: $message",
      );
}

class ShopException
    extends GameException {
  ShopException(String message)
    : super(
        "Error a la botiga: $message",
      );
}

class ValidationException
    extends GameException {
  ValidationException(String message)
    : super(
        "Dades no vàlides: $message",
      );
}
