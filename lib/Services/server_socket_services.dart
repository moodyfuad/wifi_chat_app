// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:network_info_plus/network_info_plus.dart';

class ServerSocketServices {
  factory ServerSocketServices() => _instance;

  static final ServerSocketServices _instance =
      ServerSocketServices._internal();
  ServerSocketServices._internal() {
    _initServer();
  }
  List<void Function(dynamic object)> onObjectReceivedCallBacks = [];
  List<void Function(Socket client)> onNewClientConnectedCallBacks = [];
  List<void Function(Socket client)> onClientDisconnectedCallBacks = [];

  static const int port = 4040;
  String? host;
  ServerSocket? _serverSocket;
  static final NetworkInfo _networkInfo = NetworkInfo();

  Future<void> _initServer() async {
    host ??= await _networkInfo.getWifiIP();
    _serverSocket ??= await ServerSocket.bind(host, port, shared: true);
  }

  void stop() {
    _serverSocket?.close();
    _serverSocket = null;
  }

  Future<void> startServer({
    void Function(dynamic object)? onObjectReceived,
    void Function(Socket client)? onNewClientConnected,
    void Function(Socket client)? onClientDisconnected,
  }) async {
    await _initServer();
    print('[+] Server : Server Listening on $host:$port');
    if (onObjectReceived != null) {
      onObjectReceivedCallBacks.add(onObjectReceived);
    }
    if (onNewClientConnected != null) {
      onNewClientConnectedCallBacks.add(onNewClientConnected);
    }
    if (onClientDisconnected != null) {
      onClientDisconnectedCallBacks.add(onClientDisconnected);
    }
    _serverSocket?.listen(
      (client) => _handelClientConnection(client),
      onDone: () {
        _serverSocket?.close();
        print("[+] Server is closed");
      },
      onError: (error) {
        print("[+] Server Error(_serverSocket.listen): $error");
      },
    );
  }

  void _handelClientConnection(Socket client) {
    //^ invoke the callback Function
    for (var fun in onNewClientConnectedCallBacks) {
      fun.call(client);
    }
    print(
        "[+] Server: Client connected: ${client.remoteAddress.address}:${client.remotePort}");
    StringBuffer buffer = StringBuffer();
    //^ handel incoming data from client
    client.listen(
      (Uint8List data) {
        print(
            "[+] Server : Data Received From ${client.remoteAddress.address}");
        print("[+] Server : Received data : ${utf8.decode(data)}");
        try {
          final stringData = String.fromCharCodes(data);
          buffer.write(stringData);
          if (stringData.endsWith('\n')) {
            print("Server : Data Contains \\n (end of the send)");
            final jsonString = buffer.toString().trim();
            buffer.clear();
            final jsonData = jsonDecode(jsonString);
            for (var fun in onObjectReceivedCallBacks) {
              fun.call(jsonData);
            }
          }
        } catch (e) {
          print("[+] Server : Error client.listen: $e");
        }
      },
      onDone: () {
        print(
            "Client disconnected: ${client.remoteAddress.address}:${client.remotePort}");
        for (var fun in onClientDisconnectedCallBacks) {
          fun.call(client);
        }
      },
      onError: (error) {
        print("[+] Server onError(client.listen): $error");
        for (var fun in onClientDisconnectedCallBacks) {
          fun.call(client);
        }
      },
    );
  }
}
