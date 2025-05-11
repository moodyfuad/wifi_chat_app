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
    try {
      _serverSocket?.listen(
        (client) {
          try {
            _handelClientConnection(client);
          } catch (e) {
            print('[+] Server _serverSocket.listen Error: $e');
          }
        },
        onDone: () {
          try {
            _serverSocket?.close();
          } catch (e) {
            print('[+] Server Error closing server socket: $e');
          }
          print("[+] Server is closed");
        },
        onError: (error) {
          print("[+] Server Error(_serverSocket.listen): $error");
        },
        cancelOnError: true,
      );
    } catch (e) {
      print("[+] Server Error(_serverSocket.listen): $e");
    }
  }

  void _handelClientConnection(Socket client) {
    //^ invoke the callback Function
    try {
      for (var fun in onNewClientConnectedCallBacks) {
        fun.call(client);
      }
      print(
          "[+] Server: Client connected: ${client.remoteAddress.address}:${client.remotePort}");
    } catch (e) {
      print('[+] Server Error Invoking callbacks: $e');
    }
    StringBuffer buffer = StringBuffer();
    //^ handel incoming data from client
    
    client.listen((Uint8List data) {
      print("[+] Server : Data Received From ${client.remoteAddress.address}");
      print("[+] Server : Received data : ${utf8.decode(data)}");
      try {
        final stringData = String.fromCharCodes(data);
        buffer.write(stringData.trim());
        if (stringData.endsWith('\n')) {
          print("[+] Server : Data Contains \\n (end of the send)");
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
    }, onDone: () {
      // print("Client disconnected: ${client.remoteAddress.address}:${client.remotePort}");
      try {
        for (var fun in onClientDisconnectedCallBacks) {
          fun.call(client);
        }
      } catch (e) {
        print('[+] Server Error Invoking callbacks: $e');
      }
    }, onError: (error) {
      try {
        print("[+] Server onError(client.listen): $error");
        // for (var fun in onClientDisconnectedCallBacks) {
        //   fun.call(client);
        // }
      } catch (e) {
        print('[+] Server Error Invoking callbacks: $e');
      }
    }, cancelOnError: true);
  }

  void _handelClientConnectionImproved(Socket client) {
    // Invoke connection callbacks
    for (final fun in onNewClientConnectedCallBacks) {
      try {
        fun.call(client);
      } catch (e) {
        print('[!] Server: Callback error: $e');
      }
    }

    print('[+] Server: Client connected: '
        '${client.remoteAddress.address}:${client.remotePort}');

    final StringBuffer buffer = StringBuffer();
    bool isProcessing = false;

    client.listen(
      (Uint8List data) async {
        if (isProcessing) return;
        isProcessing = true;

        try {
          print('[+] Server: Data received from '
              '${client.remoteAddress.address}');

          // Safely decode UTF-8 data
          final stringData = utf8.decode(data, allowMalformed: true);
          print('[+] Server: Received data: $stringData');

          buffer.write(stringData);

          // Check for message delimiter (newline)
          if (stringData.endsWith('\n')) {
            print('[+] Server: End of message detected');

            final jsonString = buffer.toString().trim();
            buffer.clear();

            if (jsonString.isEmpty) {
              print('[!] Server: Empty JSON string received');
              return;
            }

            try {
              // Validate and parse JSON
              final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
              print('[+] Server: Successfully parsed JSON');

              // Process callbacks
              for (final fun in onObjectReceivedCallBacks) {
                try {
                  // await
                  fun.call(jsonData);
                } catch (e) {
                  print('[!] Server: Callback processing error: $e');
                }
              }
            } on FormatException catch (e) {
              print('[!] Server: Malformed JSON: $jsonString');
              print('[!] Server: JSON error details: $e');
              // Optionally send error response to client
              client.write('{"error":"Invalid JSON format"}');
            }
          }
        } catch (e) {
          print('[!] Server: Unexpected error in data handler: $e');
          buffer.clear(); // Reset buffer on critical errors
        } finally {
          isProcessing = false;
        }
      },
      onError: (error) {
        print('[!] Server: Socket error: $error');
        _cleanupClient(client);
      },
      onDone: () {
        print('[+] Server: Client disconnected: '
            '${client.remoteAddress.address}:${client.remotePort}');
        _cleanupClient(client);
      },
      cancelOnError: true,
    );
  }

  void _cleanupClient(Socket client) {
    try {
      for (final fun in onClientDisconnectedCallBacks) {
        try {
          fun.call(client);
        } catch (e) {
          print('[!] Server: Disconnect callback error: $e');
        }
      }

      client.destroy();
    } catch (e) {
      print('[!] Server: Error during client cleanup: $e');
    }
  }
}
