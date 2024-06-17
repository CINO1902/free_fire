import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:free_fire/free_fire_socket/exceptions/FreeFireSocketException.dart';
import 'package:free_fire/free_fire_socket/helpers/socket_config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kDefaultPersistKey = 'K-es';

class FreeFireSocketService<T> {
  late IOWebSocketChannel? _channel;
  late SharedPreferences? _prefs;
  late final SocketConfig _socketConfig;

  final StreamController<T> _streamController = StreamController<T>.broadcast();
  Stream<T> get stream => _streamController.stream;

  FreeFireSocketService(this._socketConfig) {
    if (T == dynamic) {
      throw FreeFireSocketException('Type cannot be of type dynamic');
    }
  }

  Future<void> init() async {
    // Moved initialization logic to a separate method for clarity
    if (_socketConfig.persistStream) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<void> connect() async {
    try {
      if (_socketConfig.listen) {
        _channel = IOWebSocketChannel.connect(_socketConfig.ws);
        _channel?.stream.listen((json) async {
          if (_socketConfig.persistStream) {
            var old = _prefs?.getStringList(kDefaultPersistKey) ?? [];
            old.add(json);
            var p = await _prefs?.setStringList(kDefaultPersistKey, old);
            if (p == false) {
              log('Persistence Failed', name: 'Persisting essage');
            }
          }
          _streamController.add(json as T);
        });
      } else {
        throw FreeFireSocketException(
            'Socket Config value [listen] is set to false');
      }
    } on SocketException catch (e) {
      throw FreeFireSocketException(e.message);
    } catch (e) {
      throw FreeFireSocketException(
          'Socket Config value [listen] is set to false');
    }
  }

  void close() {
    _channel?.sink.close();
  }

  Future<void> send(String message,
      {String persistKey = 'defaultPersistKey'}) async {
    if (_socketConfig.persistStream) {
      var old = _prefs?.getStringList(persistKey) ?? [];
      old.add(message);
      var success = await _prefs?.setStringList(persistKey, old);
      if (success == false) {
        log('Persistence Failed', name: 'Persisting message');
      }
    }
    _channel?.sink.add(message);
  }

  void dispose() {
    _streamController.close();
  }

  Future<List<String>> getPersistedData(
      [String persistKey = kDefaultPersistKey]) async {
    if (_socketConfig.persistStream) {
      _prefs ??= await SharedPreferences.getInstance();
      return _prefs?.getStringList(persistKey) ?? [];
    }
    return [];
  }

  Future<List<String>> actOnId(String id, CrudAction action,
      {String? newValue, String persistKey = 'defaultPersistKey'}) async {
    if (_socketConfig.persistStream) {
      _prefs ??= await SharedPreferences.getInstance();
      List<String> items = _prefs?.getStringList(persistKey) ?? [];

      switch (action) {
        case CrudAction.delete:
          items.removeWhere((item) => item.contains(id));
          break;
        case CrudAction.update:
          if (newValue != null) {
            int index = items.indexWhere((item) => item.contains(id));
            if (index != -1) {
              items[index] = newValue;
            }
          }
          break;
        default:
          throw ArgumentError('Invalid action: $action');
      }

      await _prefs?.setStringList(persistKey, items);
      return items;
    }
    return [];
  }

  Future<void> clearPersistedData(
      [String persistKey = kDefaultPersistKey]) async {
    if (_socketConfig.persistStream) {
      _prefs ??= await SharedPreferences.getInstance();
      _prefs?.remove(persistKey);
    }
  }
}

enum CrudAction { delete, update }
