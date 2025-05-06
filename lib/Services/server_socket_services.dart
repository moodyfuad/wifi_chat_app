// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/model_types.dart';
import 'package:wifi_chat/mini_games/x_o/models/x_o_invitation_model.dart';

class ServerSocketServices {
  ServerSocketServices() {
    _initServer();
  }
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
    // void Function(dynamic object)? onImageRequestReceived,
    void Function(dynamic object)? onObjectReceived,
    void Function(Socket client)? onNewClientConnected,
    void Function(Socket client)? onClientDisconnected,
  }) async {
    await _initServer();
    print('[+] Server : Server Listening on $host:$port');

    _serverSocket?.listen(
      (client) => _handelClientConnection(
          client,
          onObjectReceived,
          // onImageRequestReceived,
          onNewClientConnected,
          onClientDisconnected),
      onDone: () {
        _serverSocket?.close();
        print("server is closed");
      },
      onError: (error) {
        print("[+] Server Error(_serverSocket.listen): $error");
      },
    );
  }

  void _handelClientConnection(
      Socket client,
      void Function(dynamic object)? onObjectReceived,
      // void Function(dynamic object)? onImageRequestReceived,
      void Function(Socket client)? onClientConnect,
      void Function(Socket client)? onClientDisconnected) {
    //^ invoke the callback Function
    onClientConnect?.call(client);
    print(
        "[+] Server: Client connected: ${client.remoteAddress.address}:${client.remotePort}");
    StringBuffer buffer = StringBuffer();
    //^ handel incoming data from client
    client.listen(
      (Uint8List data) {
        print(
            "[+] Server : Data Received From ${client.remoteAddress.address}: ${utf8.decode(data)}");
        print("[+] Server : Received data : ${utf8.decode(data)}");
        try {
          final stringData = String.fromCharCodes(data);
          buffer.write(stringData);
          if (stringData.endsWith('\n')) {
            print("Server : Data Contains \\n (end of the send)");
            final jsonString = buffer.toString().trim();
            buffer.clear();
            final jsonData = jsonDecode(jsonString);
            //* the data is message
            if (jsonData[JsonKeys.modelType] == ModelTypes.xoInvitation.name) {
              print("[+] Server : Data Received is Message");
              final message = XOInvitationModel.fromJson(jsonData);
              print('[+] Server($host): Received $jsonData');
              // //* echo to the client
              onObjectReceived?.call(message);
            } else if (jsonData[JsonKeys.modelType] ==
                ModelTypes.message.name) {
              print("[+] Server : Data Received is Message");
              final message = MessageModel.fromJson(jsonData);
              print('[+] Server($host): Received $jsonData');
              // //* echo to the client
              onObjectReceived?.call(message);
            }
          }
        } catch (e) {
          print("Error decoding data: $e");
        }
      },
      onDone: () {
        print(
            "Client disconnected: ${client.remoteAddress.address}:${client.remotePort}");

        onClientDisconnected?.call(client);
      },
      onError: (error) {
        print("[+] Server onError(client.listen): $error");
        onClientDisconnected?.call(client);
      },
    );
  }
}
