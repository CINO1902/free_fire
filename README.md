# free_fire

A Flutter package for WebSocket communication and persistent data storage using SharedPreferences.

## Features

- **WebSocket Integration**: Connects to WebSocket servers and manages bidirectional communication.
- **Persistent Data Storage**: Stores data locally for seamless app state persistence.

## Getting Started

This project is a Flutter plugin package that simplifies WebSocket handling and persistent data storage.

### Installation

Add `free_fire` to your `pubspec.yaml` file:

```yaml
dependencies:
  free_fire:
    git:
      url: https://github.com/CINO1902/free_fire.git
      ref: main
```


Run `flutter pub get` to install the package.

### Usage

Initialize and use `FreeFireSocket` to connect to a WebSocket server and manage persistent data:

```dart
import 'package:flutter/material.dart';
import 'package:free_fire/free_fire_socket/free_fire_socket.dart';
import 'package:free_fire/free_fire_socket/helpers/socket_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final socket = FreeFireSocket<String>();
  await socket.init(SocketConfig(
    persistStream: true,
    ws: 'wss://example.com',
    listen: true,
  ));

  // Use socket.send() to send messages and socket.stream to listen to incoming messages
}
```

### Closing

This README provides an overview of the `free_fire` package, including installation instructions, usage examples, and how to add repository URL and contributors to your `pubspec.yaml`. For more detailed information, refer to the [online Flutter documentation](https://flutter.dev/docs).
