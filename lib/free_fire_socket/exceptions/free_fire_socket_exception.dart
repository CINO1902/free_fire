import 'dart:io';

/// Exception thrown when there is an error related to the FreeFireSocket.
///
/// This exception extends [SocketException] and provides additional context
/// specific to the FreeFire package.
class FreeFireSocketException extends SocketException {
  /// Constructs a [FreeFireSocketException] with the specified error [message].
  FreeFireSocketException(String message) : super(message);

  @override
  String get message => '[FreeFireSocketException]: ${super.message}';
}
