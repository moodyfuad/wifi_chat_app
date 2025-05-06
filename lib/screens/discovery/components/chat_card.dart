import 'package:flutter/material.dart';
import 'package:wifi_chat/data/models/message_model.dart';
import 'package:wifi_chat/data/models/user_model.dart';

Card getChatCart(
    {required UserModel user,
    required bool online,
    MessageModel? lastMessage}) {
  return Card(
    semanticContainer: true,
    margin: const EdgeInsets.all(5),
    child: ListTile(
      title: Text(user.name.toUpperCase()),
      subtitle: Text(lastMessage == null ? user.host : lastMessage.content),
      leading: Hero(
        tag: user.host,
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
      trailing: online
          ? const Icon(
              Icons.radio_button_on_outlined,
              color: Colors.green,
            )
          : const SizedBox(
              width: 0,
              height: 0,
            ),
    ),
  );
}
