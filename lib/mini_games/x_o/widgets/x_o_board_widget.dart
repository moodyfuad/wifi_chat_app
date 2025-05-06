import 'package:flutter/material.dart';
import 'package:wifi_chat/mini_games/x_o/models/pice_samples.dart';
import 'package:wifi_chat/mini_games/x_o/models/x_o_board_model.dart';
import 'package:wifi_chat/mini_games/x_o/models/x_o_peiceModel.dart';
import 'package:wifi_chat/mini_games/x_o/widgets/player_pice.dart';

class XOBoardWidget extends StatefulWidget {
  const XOBoardWidget({super.key});

  @override
  State<XOBoardWidget> createState() => _XOBoardWidgetState();
}

class _XOBoardWidgetState extends State<XOBoardWidget>
    with SingleTickerProviderStateMixin {
  final XOBoardModel _board = XOBoardModel();
  static const double _paddingValue = 15;
  List<GlobalKey> keys = [];
  final GlobalKey _gridkey = GlobalKey();
  Size size = const Size(50, 50);
  late List<PlayerPice> xPices;

  Offset _getGridPos() {
    final RenderBox gridbox =
        _gridkey.currentContext!.findRenderObject() as RenderBox;
    return gridbox.localToGlobal(Offset.zero);
  }

  void _moveMarkHere(GlobalKey boxKey, int toIndex) {
    final RenderBox box =
        boxKey.currentContext!.findRenderObject() as RenderBox;
    final Offset boxPos = box.localToGlobal(Offset.zero);
    final int toMove = _board.xMoves % 3;
    _board.isXturn ? _board.moveX(toIndex) : _board.moveO(toIndex);
    xPices[toMove].position = boxPos;
  }

  @override
  void initState() {
    if (mounted) {
      xPices = _getXPeices();
    }
    super.initState();

    // gridPos = _getGridPos();
  }

  @override
  Widget build(BuildContext context) {
    keys.clear();
    return Stack(
      fit: StackFit.loose,
      children: [
        GridView.builder(
            key: _gridkey,
            padding: const EdgeInsets.all(_paddingValue),
            itemCount: 9,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (_, index) {
              var key = GlobalKey();
              keys.add(key);
              return GestureDetector(
                key: key,
                onTap: () {
                  setState(() {
                    _moveMarkHere(key, index);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(_paddingValue),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      _board.board[index]
                          .sample, // or 'O' based on the game state
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }

  List<PlayerPice> _getXPeices() {
    return List.generate(
        3,
        (i) => PlayerPice(
            playerPice: XOPieceModel(index: 0, sample: XOPieceModel.xSample),
            position: Offset(50 * i + 0, -20) - _getGridPos(),
            size: const Size(50, 50),
            paddingValue: _paddingValue));
  }

  Widget _getPlayerPice(Offset position, XOPieceModel peice) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Easing.emphasizedAccelerate,
      left: position.dx + _paddingValue,
      top: position.dy + _paddingValue,
      width: size.width - (_paddingValue * 2),
      height: size.height - (_paddingValue * 2),
      child: Container(
        padding: const EdgeInsets.all(0),

        // margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: peice.sample == PiceSamples.o ? Colors.red : Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            peice.sample,
            style: const TextStyle(fontSize: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
