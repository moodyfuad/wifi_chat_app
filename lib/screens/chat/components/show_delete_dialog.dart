import 'package:flutter/material.dart';
import 'package:wifi_chat/data/models/message_model.dart';

void showDeleteDialog(
      BuildContext context, MessageModel message, void Function() onDelete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Message',
          style: TextStyle(fontSize: 18),
        ),
        content: const Text(
          'Do you want to Delete this message?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
              onDelete(); // Your resend implementation
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.end,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }