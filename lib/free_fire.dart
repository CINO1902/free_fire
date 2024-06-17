/// Exports for the FreeFire package:
///
/// - [FreeFireSocket]: Main class for WebSocket communication.
/// - [SocketConfig]: Helper class for configuring WebSocket connections.
/// - [FreeFireStreamBuilder]: Widget for building UI based on WebSocket data streams.
export 'package:free_fire/free_fire_socket/free_fire_socket.dart';
export 'package:free_fire/free_fire_socket/helpers/socket_config.dart';
export 'package:free_fire/free_fire_socket/services/free_fire_stream_builder.dart';

/// A utility class for managing exports and versioning within the FreeFire package.
///
/// This class exports essential components of the FreeFire package, including the main
/// socket class, socket configuration helpers, and a stream builder for WebSocket data.
/// It also defines the current version [v] of the FreeFire package.
class FreeFire {
  /// Current version of the FreeFire package.
  static String v = '0.0.2';
}
