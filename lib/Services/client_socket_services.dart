// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:wifi_chat/Services/server_socket_services.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/user_model.dart';

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
          await Socket.connect(host, port, timeout: const Duration(seconds: 2));
      //         .catchError((e) {
      //   print('[+] Client Error: $e');
      //   return e;
      // });
      print('[+] Connected to $host:$port');
      try {
        onConnectionSuccess(_socket!);
      } catch (e) {
        print('[+] Client Error invoking callback: $e');
      }
    } catch (error) {
      print(
          '[+] Connecttion Failed to host :[${_socket?.address.address ?? 'unknown'}]');
      // return;
      try {
        onConnectionFailed(error, _socket);
      } catch (e) {
        print('[+] Client Error invoking callback: $e');
      }
    }
  }

  void sendMapped(Map<String, dynamic> mappedObject,
      {void Function(SocketException error)? onError}) {
    try {
      if (_socket == null) {
        throw Exception('[+] Client: Not connected to server');
      }
      _socket!
          .write(jsonEncode(mappedObject) + '\n'); // Add newline as delimiter
      _socket!.remoteAddress.address;
      print("[+] Client sent mappedObject, to: $host");
    } on SocketException catch (e, _) {
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

  Future<void> disconnect() async {
    try {
      await _socket?.flush();
      await _socket?.close();
      _socket = null;
    } catch (e) {
      print('[+] client disconnect Error: $e');
    }
  }
}
