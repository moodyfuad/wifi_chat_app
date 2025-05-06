import 'dart:io';
import 'dart:typed_data';
import 'package:network_info_plus/network_info_plus.dart';

class SocketServices {
  static const int _port = 4040;
  static int get port => _port;
  static String? get host => _host;

  static ServerSocket? _serverSocket;
  static Socket? _clientSocket;
  static final NetworkInfo _networkInfo = NetworkInfo();
  static String? _host;

  Future<void> hostImage(Uint8List imageBytes) async {
    if (_serverSocket != null) return;

    _host ??= await _networkInfo.getWifiIP();
    _serverSocket ??= await ServerSocket.bind(_host, _port, shared: true);

    _serverSocket?.listen(
      (socket) async {
        socket.setOption(SocketOption.tcpNoDelay, true);
        socket.add(imageBytes);
        await socket.flush();
        // await socket.close();
        socket.destroy();
        print('[+] Image sent to ${socket.address} on port ${socket.port}');
      },
      onDone: () {
        _serverSocket?.close();
        _serverSocket = null;
        print('server socket closed');
      },
    );
  }

  Future<Uint8List?> getImage(String host) async {
    try {
      _clientSocket = await Socket.connect(host, _port,
          timeout: const Duration(seconds: 3));
      // search SourceAddress and SourcePort
      _clientSocket?.setOption(SocketOption.tcpNoDelay, true);
      await _clientSocket?.flush();
      BytesBuilder bytesBuilder = BytesBuilder();

      //! List<Uint8List> uint8List = await _clientSocket!.toList();
      await for (var element in _clientSocket!) {
        bytesBuilder.add(element);
      }
      return bytesBuilder.takeBytes();
    } catch (e) {
      print('Error connecting to $host: $e');
      return null;
    } finally {
      _clientSocket?.close();
    }
  }
}
