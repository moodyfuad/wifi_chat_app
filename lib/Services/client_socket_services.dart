// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:wifi_chat/Services/server_socket_services.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/mini_games/x_o/models/x_o_invitation_model.dart';

class ClientSocketServices {
  static const String imageRequestString = "Profileimagewkfnqi3242mo2id2942";
  final String host;
  String name;
  final int port = ServerSocketServices.port;
  Socket? _socket;

  ClientSocketServices({required this.name, required this.host});

  Future<void> connect(
      {required void Function(Socket client) onConnectionSuccess,
      required void Function(dynamic error, Socket? client)
          onConnectionFailed}) async {
    //* the receiver is the server on the other device
    try {
      _socket =
          await Socket.connect(host, port, timeout: const Duration(seconds: 1));
      print('[+] Connected to $host:$port');
      onConnectionSuccess(_socket!);
    } catch (error) {
      print('[+] Connecttion Failed to host :[${_socket?.address.address}]');
      onConnectionFailed(error, _socket);
    }
  }

  void sendMessage(MessageModel message,
      {void Function(dynamic error)? onError}) {
    try {
      if (_socket == null) throw Exception('[+] Not connected to server');
      final jsonData = switch (message) {
        XOInvitationModel invi => invi.toJson(),
        _ => message.toJson()
      };
      _socket!.write(jsonEncode(jsonData) + '\n'); // Add newline as delimiter
      print("[+] Message sent from: ${message.senderName} to: $host");
    } catch (e) {
      onError?.call(e);
    }
  }

  //todo : implement this part
  void sendObject(dynamic object) {
    if (_socket == null) throw Exception('Not connected to server');

    if (object is MessageModel || object is UserModel) {
      // Send JSON-serializable objects
      final jsonData = object.toJson();
      _socket!.write(jsonEncode(jsonData) + '\n'); // Add newline as delimiter
    } else if (object is File) {
      // Send file
      _sendFile(object);
    } else {
      throw Exception('Unsupported object type');
    }
  }

  Future<void> _sendFile(File file) async {
    final fileName = path.basename(file.path);
    final fileSize = await file.length();
    final fileBytes = await file.readAsBytes();

    // Send metadata first
    final metadata = {
      'type': 'file',
      'name': fileName,
      'size': fileSize,
    };
    _socket!.write(jsonEncode(metadata) + '\n');

    // Send file in chunks
    const chunkSize = 1024;
    for (var i = 0; i < fileBytes.length; i += chunkSize) {
      final end =
          (i + chunkSize < fileBytes.length) ? i + chunkSize : fileBytes.length;
      _socket!.add(fileBytes.sublist(i, end));
      await _socket!.flush();
    }
    _socket!.write('\n');
  }

  void disconnect() async {
    try {
      await _socket?.flush();
      // await _socket?.close();
      _socket?.destroy();
      _socket = null;
    } catch (e) {
      print(e);
    }
  }
}
