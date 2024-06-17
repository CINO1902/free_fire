import 'package:free_fire/free_fire_socket/helpers/socket_config.dart';
import 'package:free_fire/free_fire_socket/services/socket_service.dart';

/// A wrapper class for managing WebSocket communication through [FreeFireSocketService].
///
/// The [FreeFireSocket] class simplifies WebSocket handling by encapsulating
/// [FreeFireSocketService] initialization, connection, and message sending.
/// It provides access to the WebSocket stream and methods for closing connections
/// and disposing resources.
class FreeFireSocket<T> {
  late FreeFireSocketService<T> service;

  /// Creates a [FreeFireSocket] instance.
  FreeFireSocket();

  /// Initializes the WebSocket connection with the provided [config].
  ///
  /// This method initializes the [FreeFireSocketService], connects to the WebSocket
  /// server, and prepares to send and receive messages.
  Future<void> init(SocketConfig config) async {
    service = FreeFireSocketService<T>(config);
    await service.init();
    await service.connect();
  }

  /// Stream of data received from the WebSocket.
  Stream<T> get stream => service.stream;

  /// Closes the WebSocket connection.
  void close() {
    service.close();
  }

  /// Sends a [message] to the WebSocket server.
  ///
  /// Optionally persists the message using [persistKey] if configured in [SocketConfig].
  void send(String message, {String persistKey = ''}) {
    service.send(message, persistKey: persistKey);
  }

  /// Disposes of resources used by the WebSocket service.
  void dispose() {
    service.dispose();
  }
}
