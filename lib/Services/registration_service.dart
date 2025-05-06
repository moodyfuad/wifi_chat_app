import 'dart:io';
import 'dart:typed_data';

import 'package:bonsoir/bonsoir.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_chat/Services/discovery_service.dart';

class RegistrationService {
  BonsoirBroadcast? broadcast;
  ServerSocket? _serverSocket;

  Future<void> regiser({required String name, Uint8List? imagebytes}) async {
    final service = _createService(name);
    if (imagebytes != null) {
      _hostImage(imagebytes);
    }

    if (broadcast != null) await unregister();
    broadcast ??= BonsoirBroadcast(service: service);
    await broadcast?.ready;
    if (!broadcast!.isReady || broadcast!.isStopped) {
      await regiser(name: name, imagebytes: imagebytes);
      return;
    }
    await broadcast?.start();
    print('Broadcasting service: ${service.name} on port ${service.port}');
  }

  Future<void> unregister() async {
    if (broadcast == null) return;
    await broadcast?.stop();
    if (broadcast != null) broadcast = null;
    await stopImageHosting();
  }

  static BonsoirService _createService(String name) {
    return BonsoirService(
        name: name,
        type: DiscoveryService.serviceType,
        port: DiscoveryService.port,
        attributes: _createAttri());
  }

  static Map<String, String> _createAttri() {
    return {
      'time': DateTime.now().toString(),
      'string': 'isString',
    };
  }

  Future<void> stopImageHosting() async {
    try {
      await _serverSocket?.close();
      _serverSocket = null;
    } catch (e) {
      print('[+] Error closing the server socket in ((RegistrationService))');
    }
  }

  Future<void> _hostImage(Uint8List imageBytes) async {
    final String? host = await NetworkInfo().getWifiIP();

    _serverSocket ??= await ServerSocket.bind(host, DiscoveryService.imagesPort,
        shared: true);

    _serverSocket?.listen(
      (socket) async {
        socket.setOption(SocketOption.tcpNoDelay, true);
        socket.add(imageBytes);
        await socket.flush();
        // await socket.close();
        print('[+] Image sent to ${socket.address} on port ${socket.port}');
        try {
          socket.destroy();
        } catch (e) {}
      },
      onDone: () {
        _serverSocket?.close();
        print('server socket closed');
      },
    );
  }
}
