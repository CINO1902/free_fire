Here's the updated documentation for the `FreeFire` Flutter package, incorporating version 0.0.2 and refining the content for clarity and completeness:

```markdown
# FreeFire Flutter Package v0.0.2

FreeFire is a Flutter package designed to simplify WebSocket communication and persistent data storage in Flutter applications.

## Features

- **WebSocket Integration**: Connects to WebSocket servers and manages bidirectional communication.
- **Persistent Data Storage**: Stores data locally using `SharedPreferences` for seamless app state persistence.

## Installation

Add `free_fire` to your `pubspec.yaml` file:

```yaml
dependencies:
  free_fire:
    git:
      url: https://github.com/CINO1902/free_fire
      ref: main
```

Run `flutter pub get` to install the package.

## Usage

### Initialize FreeFireSocket

```dart
import 'package:flutter/material.dart';
import 'package:free_fire/free_fire_socket/free_fire_socket.dart';
import 'package:free_fire/free_fire_socket/helpers/socket_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FreeFireSocket with SocketConfig
  final socket = FreeFireSocket<String>();
  await socket.init(SocketConfig(
    persistStream: true, // Enable persistent data storage
    ws: 'wss://example.com', // WebSocket URL
    listen: true, // Listen for incoming messages
  ));
}
```

### Sending Messages

```dart
// Send a message through the WebSocket
socket.send('{"message": "Hello!"}');
```

### Receiving Messages

```dart
// Use FreeFireStreamBuilder to listen to incoming messages
FreeFireStreamBuilder<String>(
  socket: socket,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data!);
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return Text('Waiting for data...');
    }
  },
)
```

### Managing Persistent Data

```dart
// Store and retrieve persistent data
await socket.service.send('{"Name":"John","message":"I Love this app","senderId":"Caleb@gmail.com","receiverId":"Jesse@gmail.com","type":"message"}');
List<String> messages = await socket.service.getPersistedData();
print('Persisted Messages: $messages');
```

### Closing the Connection

```dart
// Close the WebSocket connection
socket.close();
```

## API Reference

### FreeFireSocketService Class

#### Methods

- `init()`: Initializes the WebSocket connection and persistent data storage.
- `send(String message)`: Sends a message through the WebSocket.
- `getPersistedData()`: Retrieves persisted data from local storage.
- `clearPersistedData()`: Clears persisted data from local storage.

### FreeFireStreamBuilder Widget

#### Usage

- `builder`: A builder function that provides a snapshot of incoming data.

## Main Contributors

- **[Jesse Dan Amuda](https://github.com/Jesse-Dan)** - Developed FreeFireStreaBuilder and Persistance Feautures along with socket matter build.

- **[Caleb Oruta](https://github.com/CINO1902)** - Developed Exception Handling Methods Fixed major bugs while [persistStream] is true

- **[Daniel Oluremi](https://github.com/daniel-py)** - Developed Exception Handling Methods Fixed major bugs while [persistStream] is true

## License

This project is licensed under the MIT License - see the LICENSE file for details.
```

This documentation now includes detailed sections on installation, usage examples for initializing `FreeFireSocket`, sending and receiving messages, managing persistent data, closing connections, an API reference for `FreeFireSocketService` and `FreeFireStreamBuilder`, contributors, and license information. Adjust the URLs, contributor names, and other details as per your actual project specifics.