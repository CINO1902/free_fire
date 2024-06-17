import 'dart:io';

class FreeFireSocketException extends SocketException {
  FreeFireSocketException(super.message);

  @override
  String get message => '[FreeFireSocketExeption]: ${super.message}';
}
