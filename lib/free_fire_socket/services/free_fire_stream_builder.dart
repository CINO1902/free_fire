import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_fire/free_fire_socket/free_fire_socket.dart';

/// A Flutter widget that listens to a stream from a [FreeFireSocket] and rebuilds
/// itself with the latest data received.
///
/// Use [FreeFireStreamBuilder] to integrate WebSocket stream data into your
/// Flutter UI using [StreamBuilder]. It allows you to define a builder function
/// that determines how the UI should react to new data events from the WebSocket.
class FreeFireStreamBuilder<T> extends StatelessWidget {
  /// The WebSocket socket instance to listen to.
  final FreeFireSocket<T> socket;

  /// The builder function that will be called with a build context and the
  /// latest snapshot of data from the WebSocket stream.
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;

  /// The initial data to provide to the stream builder.
  ///
  /// This is optional and can be used to set an initial value before any data
  /// is received from the WebSocket stream.
  final T? initialData;

  /// Creates a [FreeFireStreamBuilder] widget.
  ///
  /// [socket] is required and should be an instance of [FreeFireSocket] handling
  /// WebSocket communication.
  ///
  /// [builder] is required and specifies the build strategy to be used by the
  /// [StreamBuilder]. It should return a widget based on the latest snapshot
  /// of data received from the WebSocket stream.
  ///
  /// [initialData] can be provided to set an initial snapshot value before
  /// receiving any data from the WebSocket.
  const FreeFireStreamBuilder({
    Key? key,
    required this.socket,
    this.initialData,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      /// The stream to listen to for data updates.
      stream: socket.service.stream,

      /// The initial snapshot data to provide before any data is received.
      initialData: initialData,

      /// The builder function to execute whenever new data arrives from the stream.
      builder: builder,
    );
  }
}
