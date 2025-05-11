import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/user_model.dart';
import 'package:wifi_chat/screens/shared/utils/show_profile_picture_dialog.dart';

Card getChatCart(
    {required UserModel user,
    required bool online,
    required BuildContext context,
    MessageModel? lastMessage}) {
  return Card(
    semanticContainer: true,
    margin: const EdgeInsets.all(5),
    child: ListTile(
        title: lastMessage == null
            ? Text(user.name.toUpperCase())
            : Text('${user.name.toUpperCase()} | ${user.host}'),
        subtitle: Text(lastMessage == null ? user.host : lastMessage.content),
        leading: Hero(
          tag: user.host,
          child: GestureDetector(
            onTap: () {
              if (user.profileImage != null) {
                showProfilePictureDialog(context, user.profileImage!);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: user.profileImage == null
                  ? Container(
                      color: Colors.white,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 40,
                      ),
                    )
                  : Image.memory(
                      user.profileImage!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              online ? 'online' : 'offline',
              style: TextStyle(
                color: online ? Colors.green : Colors.red,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 5),
          ],
        )),
  );
}


