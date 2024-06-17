import 'package:free_fire/free_fire_socket/helpers/socket_config.dart';
import 'package:free_fire/free_fire_socket/services/socket_service.dart';

class FreeFireSocket<T> {
  late FreeFireSocketService<T> service;

  FreeFireSocket();

  Future<void> init(SocketConfig config) async {
    service = FreeFireSocketService<T>(config);
    await service.init();
    await service.connect();
  }

  Stream<T> get stream => service.stream;

  void close() {
    service.close();
  }

  void send(String message, {String persistKey = ''}) {
    service.send(message, persistKey: persistKey);
  }

  void dispose() {
    service.dispose();
  }
}
