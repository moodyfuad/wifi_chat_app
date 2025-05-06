import 'package:flutter/material.dart';
import 'package:wifi_chat/mini_games/x_o/models/pice_samples.dart';
import 'package:wifi_chat/mini_games/x_o/models/x_o_peiceModel.dart';

class PlayerPice extends StatefulWidget {
  PlayerPice(
      {super.key,
      required this.playerPice,
      required this.position,
      required this.size,
      required this.paddingValue});

  final XOPieceModel playerPice;
  Offset position;
  Size size;
  final double paddingValue;

  

  @override
  State<PlayerPice> createState() => _PlayerPiceState();
}

class _PlayerPiceState extends State<PlayerPice> {
  void move(Offset position, Size size){
    
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Easing.emphasizedAccelerate,
      left: widget.position.dx + widget.paddingValue,
      top: widget.position.dy + widget.paddingValue,
      width: widget.size.width - (widget.paddingValue * 2),
      height: widget.size.height - (widget.paddingValue * 2),
      child: Container(
        padding: const EdgeInsets.all(0),

        // margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: widget.playerPice.sample == PiceSamples.x ?  Colors.red : Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            widget.playerPice.sample, // or 'O' based on the game state
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
