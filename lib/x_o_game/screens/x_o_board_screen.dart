import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/providers/x_o_provider.dart';
import 'package:wifi_chat/x_o_game/models/x_o_peiceModel.dart';

class XOBoardWidget extends StatelessWidget {
  const XOBoardWidget({super.key, required this.title});
  final String title;
  static const double _margin = 15;
  static const double _topGridMargin = 100;

  @override
  Widget build(BuildContext context) {
    Provider.of<XOProvider>(context, listen: false).invitationAccepted = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<XOProvider>(context, listen: false).reset();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Consumer<XOProvider>(builder: (context, prv, child) {
        List<int>? winIndexs = prv.board.isWin();

        return Stack(
          fit: StackFit.passthrough,
          children: [
            GridView.builder(
              padding: const EdgeInsets.only(top: _topGridMargin),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: Provider.of<XOProvider>(context, listen: false)
                  .board
                  .board
                  .length,
              itemBuilder: (BuildContext context, int index) {
                if (winIndexs != null) {
                  // _showDialog(context, prv.board.board[winIndexs.first].sample);
                  return winIndexs.contains(index)
                      ? Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              gradient:
                                  const SweepGradient(colors: Colors.accents),
                              borderRadius: BorderRadius.circular(20)),
                          child:
                              _getContainerWidget(index: index, provider: prv))
                      : _getContainerWidget(index: index, provider: prv);
                } else {
                  return _getContainerWidget(index: index, provider: prv);
                }
              },
            ),
            // if (winIndexs != null){
            //   return Container();
            //  }
          ],
        );
      }),
    );
  }

  _showDialog(BuildContext context, String winner) {
    showDialog(
      anchorPoint: Offset(0, 0),
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(
          "$winner Win",
          style: TextStyle(fontSize: 20),
        ),
        // actions: [
        //   ElevatedButton(
        //       onPressed: () {
        //         Navigator.of(context).pushAndRemoveUntil(
        //             MaterialPageRoute(builder: (_) => const MainScreen()),
        //             (route) => false);
        //       },
        //       child: const Text('Go Back'))
        // ],
      ),
    );
  }

  Widget _getContainerWidget(
      {GlobalKey? key,
      Size? size,
      required int index,
      required XOProvider provider}) {
    return GestureDetector(
      onTap: () {
        provider.move(index);
        provider.board.isWin(
          onWin: (indexs) {
            provider.board.board[indexs.first];
            // _showDialog( context, board.board[indexs.first].sample);
          },
        );
      },
      child: Container(
        key: key,
        width: size?.width,
        height: size?.height,
        margin: const EdgeInsets.all(_margin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // color: size == null ? Colors.blue : Colors.amber,
          color: switch (provider.board.board[index].sample) {
            XOPieceModel.oSample => Colors.blue,
            XOPieceModel.xSample => Colors.red,
            XOPieceModel.noSample => Colors.blueGrey,
            _ => throw UnimplementedError(),
          },
        ),
        alignment: Alignment.center,
        child: Text(
          switch (provider.board.board[index].sample) {
            XOPieceModel.oSample => 'O',
            XOPieceModel.xSample => 'X',
            XOPieceModel.noSample => '',
            _ => throw UnimplementedError(),
          },
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: (size == null ? 80 : 30), color: Colors.white),
        ),
      ),
    );
  }
}
