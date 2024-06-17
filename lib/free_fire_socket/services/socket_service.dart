import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:free_fire/free_fire_socket/exceptions/free_fire_socket_exception.dart';
import 'package:free_fire/free_fire_socket/helpers/socket_config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for managing WebSocket communication and optional data persistence.
///
/// The [FreeFireSocketService] class connects to a WebSocket server using the provided
/// [SocketConfig], manages incoming and outgoing messages, and optionally persists data
/// using [SharedPreferences].
///
/// Generics:
/// - [T]: Type of data received and sent over the WebSocket.
class FreeFireSocketService<T> {
  late IOWebSocketChannel? _channel;
  late SharedPreferences? _prefs;
  late final SocketConfig _socketConfig;

  final StreamController<T> _streamController = StreamController<T>.broadcast();

  /// Stream of data received from the WebSocket.
  Stream<T> get stream => _streamController.stream;

  /// Creates a [FreeFireSocketService] instance with the specified [socketConfig].
  ///
  /// Throws a [FreeFireSocketException] if [T] is dynamic, as it's not supported.
  FreeFireSocketService(this._socketConfig) {
    if (T == dynamic) {
      throw FreeFireSocketException('Type cannot be of type dynamic');
    }
  }

  /// Initializes the service, setting up persistence if configured.
  Future<void> init() async {
    if (_socketConfig.persistStream) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  /// Connects to the WebSocket server and starts listening for messages.
  ///
  /// Throws a [FreeFireSocketException] if connection fails or if [listen] is `false`.
  Future<void> connect() async {
    try {
      if (_socketConfig.listen) {
        _channel = IOWebSocketChannel.connect(_socketConfig.ws);
        _channel?.stream.listen((json) async {
          if (_socketConfig.persistStream) {
            var old = _prefs?.getStringList(_socketConfig.persistanceKey) ?? [];
            old.add(json);
            var p = await _prefs?.setStringList(_socketConfig.persistanceKey, old);
            if (p == false) {
              log('Persistence Failed', name: 'Persisting message');
            }
          }
          _streamController.add(json as T);
        });
      } else {
        throw FreeFireSocketException('Socket Config value [listen] is set to false');
      }
    } on SocketException catch (e) {
      throw FreeFireSocketException(e.message);
    } catch (e) {
      throw FreeFireSocketException('Socket Config value [listen] is set to false');
    }
  }

  /// Closes the WebSocket connection.
  void close() {
    _channel?.sink.close();
  }

  /// Sends a message to the WebSocket server.
  ///
  /// Optionally persists the message if [persistStream] is `true`.
  Future<void> send(String message, {String persistKey = 'defaultPersistKey'}) async {
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

  /// Disposes of resources used by the service.
  void dispose() {
    _streamController.close();
  }

  /// Retrieves persisted data from [SharedPreferences].
  Future<List<String>> getPersistedData([String? persistKey]) async {
    if (_socketConfig.persistStream) {
      _prefs ??= await SharedPreferences.getInstance();
      return _prefs?.getStringList(persistKey ?? _socketConfig.persistanceKey) ?? [];
    }
    return [];
  }

  /// Performs a CRUD action on persisted data.
  ///
  /// - [id]: Identifier for the data item to act upon.
  /// - [action]: Action to perform (delete or update).
  /// - [newValue]: Optional new value for update action.
  /// - [persistKey]: Key to use for persistence (default is 'defaultPersistKey').
  Future<List<String>> actOnId(String id, CrudAction action, {String? newValue, String persistKey = 'defaultPersistKey'}) async {
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

  /// Clears persisted data for the specified [persistKey].
  Future<void> clearPersistedData([String? persistKey]) async {
    if (_socketConfig.persistStream) {
      _prefs ??= await SharedPreferences.getInstance();
      _prefs?.remove(persistKey ?? _socketConfig.persistanceKey);
    }
  }
}

/// Enum representing CRUD actions for [actOnId] method.
enum CrudAction { delete, update }
