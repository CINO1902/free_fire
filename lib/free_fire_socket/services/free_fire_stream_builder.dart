import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_fire/free_fire_socket/free_fire_socket.dart';

class FreeFireStreamBuilder<T> extends StatelessWidget {
  final FreeFireSocket<T> socket;
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;
  final T? initialData;

  const FreeFireStreamBuilder({
    Key? key,
    required this.socket,
    this.initialData,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: socket.service.stream, initialData: initialData, builder: builder);
  }
}
