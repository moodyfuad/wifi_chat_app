import 'package:flutter/material.dart';
import 'package:wifi_chat/data/models/message_model.dart';

void showResendDialog(
      BuildContext context, MessageModel message, void Function() onResend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Resend Message',
          style: TextStyle(fontSize: 18),
        ),
        content: const Text(
          'Do you want to resend this message?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text(
              'Resend',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
              onResend(); // Your resend implementation
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.end,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ).then((shouldResend) {
      if (shouldResend == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Resending message...',
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }