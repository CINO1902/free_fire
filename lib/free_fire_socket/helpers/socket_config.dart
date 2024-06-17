import 'dart:developer';

class SocketConfig {
  final bool persistStream;
  final String ws;
  final bool listen;

  SocketConfig({
    this.persistStream = false,
    required this.ws,
    this.listen = true,
  }) {
    if (persistStream) {
      log('[SocketConfig]: persistStream [value] is still under development please use with caution');
    }
  }
}
