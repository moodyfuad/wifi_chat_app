// ignore_for_file: avoid_print
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/foundation.dart';
import 'package:wifi_chat/Services/discovery_service.dart';
import 'package:wifi_chat/Services/server_socket_services.dart';
import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/hive/helpers/chat_box_helper.dart';
import 'package:wifi_chat/data/models/user_model.dart';

class DiscoveryProvider extends ChangeNotifier {
  static BonsoirBroadcast? broadcast;
  final List<UserModel> users = [];
  bool get isDiscoveryOn => _discoveryService.isDiscoveryOn;
  final DiscoveryService _discoveryService = DiscoveryService();
  final ServerSocketServices _serverSocketService = ServerSocketServices();

  Future<void> startDiscovery() async {
    users.clear();
    await _discoveryService.startDiscovery(
      onDiscoverd: (user) async {
        var matchedUsers = users.where((u) => u.host == user.host);
        if (matchedUsers.isEmpty) {
          users.add(user);
          await ChatBoxHelper.updateUser(user);
        } else if (matchedUsers.every(
            (u) => u.discoveredDateTime!.isBefore(user.discoveredDateTime!))) {
          users.removeWhere((u) => u.host == user.host);
          users.add(user);
          await ChatBoxHelper.updateUser(user);
        }
        notifyListeners();
      },
      onDissmesed: (service) {
        users.removeWhere((user) =>
            user.discoveredDateTime ==
            DateTime.parse(service.attributes[JsonKeys.dateTime] ??
                DateTime.now().toString()));
        notifyListeners();
      },
    );
  }

  Future<void> stopDiscovery() async {
    users.clear();
    try {
      await _discoveryService.stopDiscovery();
      _serverSocketService.stop();
      notifyListeners();
    } catch (e) {
      print('[+] Error stopping Discovery: $e');
    }
  }
}
