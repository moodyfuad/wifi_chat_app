import 'package:flutter/material.dart';
import 'package:wifi_chat/mini_games/x_o/widgets/x_o_board_widget.dart';

class XOGameMainPage extends StatefulWidget {
  const XOGameMainPage({super.key});

  @override
  State<XOGameMainPage> createState() => _XOGameMainPageState();
}

class _XOGameMainPageState extends State<XOGameMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('X-O Game'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the X-O Game!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              XOBoardWidget(
                title: 'Title',
              )
            ],
          ),
        ),
      ),
    );
  }

  getXWid() {
    return Hero(
      tag: "t1",
      child: Container(
        width: 50,
        height: 50,
        color: Colors.red,
        child: const Center(
          child: Text(
            'X',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
