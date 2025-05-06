// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:wifi_chat/mini_games/x_o/models/x_o_peiceModel.dart';

class XOBoardModel {
  List<XOPieceModel> board = List.generate(9, _generator);
  static XOPieceModel _generator(int index) =>
      XOPieceModel(index: index, sample: XOPieceModel.noSample);

  int xMoves = 0;
  List<XOPieceModel> xPices =
      List.generate(3, (_) => XOPieceModel(sample: XOPieceModel.xSample));
  int oMoves = 0;
  List<XOPieceModel> oPices =
      List.generate(3, (_) => XOPieceModel(sample: XOPieceModel.oSample));
  bool isXturn = true;

  List<List<int>> winCases = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];

  // move(XOPeicemodel player, int toIndex) {
  //   switch (player.sample) {
  //     case PiceSamples.x:
  //       moveX(toIndex);
  //     case PiceSamples.o:
  //       moveO(toIndex);
  //     case PiceSamples.none:
  //       return;
  //   }
  // }

  moveO(int toIndex) {
    if (board[toIndex].sample != XOPieceModel.noSample) return;
    var pieceToMove = oPices[oMoves % 3];
    oMoves++;
    //^ clear the old place
    if (pieceToMove.index != null) {
      board[pieceToMove.index!] = XOPieceModel(sample: XOPieceModel.noSample);
    }
    //^ update the player pieces
    pieceToMove.index = toIndex;

    //^ place the piece in the board
    board[toIndex] = pieceToMove;
    // var pieceToMove = oPices[oMoves % 3];
    // oMoves++;
    // //^ place the piece in the board
    // board[toIndex] = pieceToMove;
    // board[toIndex].index = toIndex;
    // //^ clear the old place
    // if (pieceToMove.index != null) {
    //   board[pieceToMove.index!].sample = XOPieceModel.noSample;
    // }
    // //^ update the player pieces
    // oPices[(oMoves - 1) % 3].index = toIndex;
    isXturn = !isXturn;
  }

  moveX(int toIndex) {
    if (board[toIndex].sample != XOPieceModel.noSample) return;
    var pieceToMove = xPices[xMoves % 3];
    xMoves++;

    //^ clear the old place
    if (pieceToMove.index != null) {
      board[pieceToMove.index!] = XOPieceModel(sample: XOPieceModel.noSample);
    }
    //^ update the player pieces
    pieceToMove.index = toIndex;
    //^ place the piece in the board
    board[toIndex] = pieceToMove;
    // board[toIndex].index = toIndex;
    // if (pieceToMove.index != null) {
    //   board[pieceToMove.index!].sample = XOPieceModel.noSample;
    // }
    // xPices[(oMoves - 1) % 3].index = toIndex;
    isXturn = !isXturn;
  }

  List<int>? isWin({void Function(List<int> indexs)? onWin}) {
    for (List<int> winCase in winCases) {
      if (board[winCase[0]].sample == board[winCase[1]].sample &&
          board[winCase[1]].sample == board[winCase[2]].sample &&
          board[winCase[2]].sample != XOPieceModel.noSample) {
        onWin?.call(winCase);
        return winCase;
      }
    }
    return null;
  }
}

