import 'dart:developer';


/// Configuration class for WebSocket settings.
///
/// Use [SocketConfig] to configure WebSocket connection parameters,
/// including whether to persist streams, WebSocket URL ([ws]), and
/// whether to start listening immediately ([listen]).
class SocketConfig {
  /// Whether to persist the WebSocket stream.
  ///
  /// Defaults to `false`. Use with caution as this feature is still under development.
  final bool persistStream;

  /// The WebSocket URL to connect to.
  final String ws;

  ///
  final String persistanceKey;

  /// Whether to start listening to WebSocket events immediately.
  ///
  /// Defaults to `true`.
  final bool listen;

  /// Creates a [SocketConfig] instance with the specified configuration parameters.
  ///
  /// The WebSocket URL ([ws]) is required. [persistStream] defaults to `false`,
  /// and [listen] defaults to `true`.
  ///
  /// If [persistStream] is `true`, a warning message is logged indicating that
  /// this feature is still under development.
  SocketConfig({
    this.persistStream = false,
    required this.ws,
    this.listen = true,
    this.persistanceKey = 'K-es', 
  }) {
    if (persistStream) {
      log('[SocketConfig]: persistStream is still under development; please use with caution.');
    }
  }
}
