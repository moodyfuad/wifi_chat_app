import 'dart:io';
import 'dart:typed_data';

import 'package:bonsoir/bonsoir.dart';
import 'package:uuid/uuid.dart';
import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/models/user_model.dart';

class DiscoveryService {
  DiscoveryService._internal();
  static final DiscoveryService _instance = DiscoveryService._internal();
  factory DiscoveryService() => _instance;

  static const String serviceType = '_localChat._tcp';
  static const int port = 54321;
  static const int imagesPort = 54541;
  BonsoirDiscovery discovery = BonsoirDiscovery(type: serviceType);
  bool isDiscoveryOn = false;

  Future<void> startDiscovery({
    void Function(UserModel user)? onDiscoverd,
    void Function(BonsoirService service)? onDissmesed,
  }) async {
    if (discovery.isStopped) discovery = BonsoirDiscovery(type: serviceType);
    await discovery.ready;
    isDiscoveryOn = true;
    discovery.eventStream!.listen((BonsoirDiscoveryEvent event) async {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
        print(
            '[-] Found unResolved : ${event.service?.name}, resolved : ${event.isServiceResolved}');
        try {
          await event.service!.resolve(discovery.serviceResolver);
        } catch (e) {
          print('[+] Error resolving ${event.service!.name}');
        }
      }
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
        print(' [+] Found Resolved : ${event.service?.name}');
        var service = (event.service as ResolvedBonsoirService);
        try {
          var user = await _createUser(service);
          onDiscoverd?.call(user);
        } catch (e) {
          print('[+] Discovery Error : $e');
        }
        // await socketServices.connectToServer((event.service as ResolvedBonsoirService).host!);
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
        print('[-] Lost : ${event.service?.name}');
        onDissmesed?.call(event.service!);
      } else if (event.type ==
          BonsoirDiscoveryEventType.discoveryServiceResolveFailed) {
        print('[+] resolve failed  : ${event.service?.toJson()}');
      }
    }).onError((e) {
      print('[+] Error from Descovery service: $e');
    });
    await discovery.start();
  }

  Future<void> stopDiscovery() async {
    if (discovery.isStopped) return;
    try {
      await discovery.stop();
    } catch (e) {
      print('[+] Discovery stop Error : $e');
    }
    isDiscoveryOn = false;
  }

  Future<UserModel> _createUser(ResolvedBonsoirService service) async {
    final hostAsIp = await _resolveHostToIP(service.host!);
    Uint8List? imagebytes;
    try {
      imagebytes = await _getImageFromServer(hostAsIp);
    } catch (_) {}
    UserModel user = UserModel(
        host: hostAsIp,
        port: port,
        id: const Uuid().v1(),
        name: service.name,
        profileImage: imagebytes,
        discoveredDateTime: DateTime.parse(
            service.attributes[JsonKeys.dateTime] ??
                DateTime.now().toString()));
    return user;
  }

  Future<Uint8List?> _getImageFromServer(String host) async {
    try {
      final clientSocket = await Socket.connect(
          host, DiscoveryService.imagesPort,
          timeout: const Duration(seconds: 3));

      clientSocket.setOption(SocketOption.tcpNoDelay, true);
      await clientSocket.flush();
      BytesBuilder bytesBuilder = BytesBuilder();
      await for (var element in clientSocket) {
        bytesBuilder.add(element);
      }
      //? should be closed ?
      clientSocket.destroy();
      return bytesBuilder.takeBytes();
    } catch (e) {
      print('[+] Error connecting to image server $host: $e');
      return null;
    } finally {}
  }

  static Future<String> _resolveHostToIP(String host) async {
    try {
      // Remove .local suffix if present (common in mDNS/Bonsoir)
      final cleanHost = host.replaceAll('.local', '');

      // Perform DNS lookup
      final addresses = await InternetAddress.lookup(cleanHost);

      if (addresses.isEmpty) {
        throw Exception('No IP addresses found for $host');
      }

      // Return the first IPv4 address
      return addresses
          .firstWhere(
            (addr) => addr.address.contains('.'),
            orElse: () => addresses.first,
          )
          .address;
    } catch (e) {
      throw Exception('Failed to resolve $host: $e');
    }
  }
}
