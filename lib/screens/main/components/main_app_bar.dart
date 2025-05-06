import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/providers/chat_provider.dart';
import 'package:wifi_chat/providers/discovery_provider.dart';
import 'package:wifi_chat/providers/user_provider.dart';
import 'package:wifi_chat/screens/login/login_screen.dart';

AppBar getMainAppBar({String? title, required BuildContext context}) {
  return AppBar(
    title: Text(title ?? ''),
    leading: _getLogoutWidget(context),
    actions: [
      Consumer3<DiscoveryProvider, UserProvider, ChatProvider>(
        builder: (context, discoveryPrv, userPrv, chatPrv, child) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(discoveryPrv.isDiscoveryOn ? 'online' : 'offline'),
            Switch.adaptive(
                value: discoveryPrv.isDiscoveryOn,
                onChanged: (on) async {
                  if (on) {
                    // String name = userPrv.user.name;
                    await userPrv.register();
                    await discoveryPrv.startDiscovery();
                    chatPrv.startMessagingServer();
                    userPrv.user.host = chatPrv.myHost;
                  } else {
                    await userPrv.unregister();
                    await discoveryPrv.stopDiscovery();
                    chatPrv.stopMessageingServer();
                  }
                })
          ],
        ),
      )
    ],
  );
}

Widget _getLogoutWidget(BuildContext context) {
  return GestureDetector(
    onTap: () => _showLogoutDialog(context),
    child: const Icon(Icons.logout),
  );
}

_showLogoutDialog(BuildContext context) {
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        title: const Text('Go Back To Login? '),
        actions: [
          ElevatedButton(
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).unregister();
              Provider.of<DiscoveryProvider>(context, listen: false)
                  .stopDiscovery();
              Provider.of<ChatProvider>(context, listen: false)
                  .stopMessageingServer();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Yes'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}
