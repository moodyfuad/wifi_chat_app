// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:wifi_chat/mini_games/x_o/models/x_o_peiceModel.dart';

class XOBoardModel {
  List<XOPieceModel> board = List.generate(9, _generator);
  static XOPieceModel _generator(int index) =>
      XOPieceModel(boardIndex: index, sample: XOPieceModel.noSample);


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

  void reset(){
    board = List.generate(9, _generator);
    xMoves = 0;
    oMoves = 0;
    isXturn = true;
  }
  move(int toIndex) {
    switch (isXturn) {
      case true:
        moveX(toIndex);
      case false:
        moveO(toIndex);
    }
  }

  moveO(int toIndex) {
    if (isXturn) return;
    if (board[toIndex].sample != XOPieceModel.noSample) return;
    var pieceToMove = oPices[oMoves % 3];
    oMoves++;
    //^ clear the old place
    if (pieceToMove.boardIndex != null) {
      board[pieceToMove.boardIndex!] =
          XOPieceModel(sample: XOPieceModel.noSample);
    }
    //^ update the player pieces
    pieceToMove.boardIndex = toIndex;

    //^ place the piece in the board
    board[toIndex] = pieceToMove;
    isXturn = !isXturn;
  }

  moveX(int toIndex) {
    if (!isXturn) return;
    if (board[toIndex].sample != XOPieceModel.noSample) return;
    var pieceToMove = xPices[xMoves % 3];
    xMoves++;

    //^ clear the old place
    if (pieceToMove.boardIndex != null) {
      board[pieceToMove.boardIndex!] =
          XOPieceModel(sample: XOPieceModel.noSample);
    }
    //^ update the player pieces
    pieceToMove.boardIndex = toIndex;
    //^ place the piece in the board
    board[toIndex] = pieceToMove;

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
