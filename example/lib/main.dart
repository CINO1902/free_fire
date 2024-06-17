import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:free_fire/free_fire.dart';
import 'package:free_fire/free_fire_socket/services/socket_service.dart';

final config = SocketConfig(
  ws: 'ws://127.0.0.1:54623',
  persistStream: true,
  listen: true,
);

late final FreeFireSocket<String> socket;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  socket = FreeFireSocket<String>();

  await socket.init(config);

  socket.send('''{
    "Name":"Caleb",
    "message":"I Love this app",
    "senderId":"Caleb@gmail.com",
    "receiverId":"Jesse@gmail.com",
    "type":"message"
}''');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> data = [];
  var idCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Socket Stream Example'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FreeFireStreamBuilder<String>(
                socket: socket,
                initialData: 'No Data Found',
                builder: (context, snapshot) {
                  log(snapshot.toString());
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      return const Text('Connection closed');
                    case ConnectionState.none:
                      return const Text('Connection Not Found');
                    case ConnectionState.active:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('No data');
                      } else {
                        final data = snapshot.data!;
                        return Text('Data: $data');
                      }
                    default:
                      return const Text('Unknown state');
                  }
                },
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Persisted Data')),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (c, i) {
                    return GestureDetector(
                      onDoubleTap: () async {
                        data = await socket.service.actOnId(
                            idCtl.text, CrudAction.delete,
                            persistKey: 'defaultPersistKey');
                        log("Data after delete: $data");
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('$i - ${jsonDecode(data[i])['Name']}'),
                      ),
                    );
                  })
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                controller: idCtl,
                decoration: InputDecoration(labelText: 'Enter ID'),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    data.clear();
                    data.addAll(await socket.service
                        .getPersistedData('defaultPersistKey'));
                    log("Data: $data");
                    await socket.service.send('''{
                    "Name":"Caleb",
                    "message":"I Love this app",
                    "senderId":"Caleb@gmail.com",
                    "receiverId":"Jesse@gmail.com",
                    "type":"message"
                  }''');
                    setState(() {});
                  },
                  child: const Icon(Icons.smart_display),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    await socket.service
                        .clearPersistedData('defaultPersistKey');
                    data.clear();
                    log("Data cleared: $data");
                    setState(() {});
                  },
                  child: const Icon(Icons.clear_all_rounded),
                ),
                FloatingActionButton(
                  onPressed: () async {},
                  child: const Icon(Icons.delete),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    data = await socket.service.actOnId(
                        idCtl.text, CrudAction.update,
                        newValue: 'Jesse', persistKey: 'defaultPersistKey');
                    log("Data after update: $data");
                    setState(() {});
                  },
                  child: const Icon(Icons.update),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
