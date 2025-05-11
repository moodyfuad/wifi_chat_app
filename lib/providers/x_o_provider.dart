import 'package:flutter/material.dart';
import 'package:wifi_chat/Services/client_socket_services.dart';
import 'package:wifi_chat/Services/server_socket_services.dart';
import 'package:wifi_chat/data/constants/json_keys.dart';
import 'package:wifi_chat/data/models/model_types.dart';
import 'package:wifi_chat/x_o_game/enums/x_o_invitation_states.dart';
import 'package:wifi_chat/x_o_game/models/x_o_board_model.dart';
import 'package:wifi_chat/x_o_game/models/x_o_invitation_model.dart';
import 'package:wifi_chat/x_o_game/models/x_o_peiceModel.dart';

class XOProvider extends ChangeNotifier {
  XOProvider() {
    _server.onObjectReceivedCallBacks.add(_onObjectReceived);
  }
  final ServerSocketServices _server = ServerSocketServices();
  ClientSocketServices? client;
  final XOBoardModel board = XOBoardModel();
  bool? myTurn;
  XOInvitationModel? invitation;
  bool invitationAccepted = false;
  // UserModel? withUser;

  Future<void> startGame({required XOInvitationModel invitation}) async {
    this.invitation = invitation;
    await _sendInvitationAcceptedMessage();
    invitationAccepted = true;
    notifyListeners();
    invitationAccepted = false;
  }

  Future<void> endGame() async {
    _server.onObjectReceivedCallBacks.removeLast();
    try {
      client?.disconnect();
    } catch (e) {
      print('[+] Error End the game : $e');
    }
    invitationAccepted = false;
    reset();
    notifyListeners();
  }

  move(int index) {
    // invitationAccepted = false;
    if (myTurn == null && board.oMoves == 0 && board.xMoves == 0) {
      board.move(index);
      myTurn = false;
      client?.sendMapped({'index': index});
    } else if (myTurn == true) {
      board.move(index);
      client?.sendMapped({'index': index});
      myTurn = false;
    }
    notifyListeners();
  }

  void reset() {
    board.reset();
    notifyListeners();
  }

  Future<void> _sendInvitationAcceptedMessage() async {
    client = ClientSocketServices(
        name: invitation!.senderName, host: invitation!.senderHost);

    await client!.connect(onConnectionSuccess: (socket) {
      print('[+] Connecttion Success');
    }, onConnectionFailed: (error, socket) {
      print('[+] Error connecting ');
      return;
    });
    invitation!.state = XOInvitationStates.accepted;
    client!.sendMapped(
      invitation!.toJson(),
      onError: (error) {
        print('[+] Error Sending Back Accepted invitation');
        return;
      },
    );
  }

  _onObjectReceived(dynamic object) async {
    if (object[JsonKeys.modelType] == ModelTypes.xoInvitation.name) {
      await _onInitationReceived(XOInvitationModel.fromJson(object));
    } else if (object[JsonKeys.modelType] == ModelTypes.xoPiece.name) {
      await _onPlayerMoved(XOPieceModel.fromMap(object));
    } else if (object['index'] != null) {
      board.move(object['index']);
      myTurn = true;

      notifyListeners();
    }
  }

  _onPlayerMoved(XOPieceModel piece) {
    board.moveO(piece.boardIndex!);
    // bool isWin = board.isWin() == null;
    notifyListeners();
  }

  Future<void> _onInitationReceived(XOInvitationModel invitation) async {
    if (invitation.state == XOInvitationStates.accepted &&
        invitation.senderHost == _server.host) {
      this.invitation = invitation;
      client = ClientSocketServices(
          name: invitation.senderName, host: invitation.receiverHost);

      await client!.connect(onConnectionSuccess: (socket) {
        print('[+] Connecttion Success');
      }, onConnectionFailed: (error, socket) {
        print('[+] Error connecting ');
        return;
      });
      invitationAccepted = true;
      notifyListeners();
      invitationAccepted = false;
      client?.sendMapped(invitation.toJson());
    }
  }
}
