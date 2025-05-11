import 'dart:typed_data';

import 'package:flutter/material.dart';

void showProfilePictureDialog(BuildContext context, Uint8List imageBytes) {
  showDialog(
    context: context,
    builder: (context) {
      var size = MediaQuery.of(context).size;
      return Center(
        child: Container(
          width: size.width * 0.8,
          height: size.width * 0.8,
          foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: MemoryImage(
                imageBytes,
              ))),
        ),
      );
    },
  );
}