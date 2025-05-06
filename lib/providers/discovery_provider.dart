// ignore_for_file: avoid_print
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/foundation.dart';
import 'package:wifi_chat/Services/discovery_service.dart';
import 'package:wifi_chat/Services/server_socket_services.dart';
import 'package:wifi_chat/data/models/user_model.dart';

class DiscoveryProvider extends ChangeNotifier {
  static BonsoirBroadcast? broadcast;
  final List<UserModel> users = [];
  bool get isDiscoveryOn => _discoveryService.isDiscoveryOn;
  final DiscoveryService _discoveryService = DiscoveryService();
  final ServerSocketServices _serverSocketService = ServerSocketServices();

  Future<void> startDiscovery() async {
    users.clear();
    _discoveryService.startDiscovery(
      onDiscoverd: (user) {
        users.removeWhere((u) => u.host == user.host);

        users.add(user);

        notifyListeners();
      },
      onDissmesed: (service) {
        users.removeWhere((user) => user.name == service.name);
        notifyListeners();
      },
    );
  }

  Future<void> stopDiscovery() async {
    users.clear();
    await _discoveryService.stopDiscovery();
    _serverSocketService.stop();
    notifyListeners();
  }
}
