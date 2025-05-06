import 'dart:ui';

class XOPlayer {
  XOPlayer({required this.piceSample, required this.color});

  String? host;
  int? port;
  String? name;
  final String piceSample;
  final Color color;
  final List<int> picesIndex = [0, 1, 2];
  int _moves = 0;

  int get piceIndexToMove => _movePice();

  int _movePice() {
    _moves++;
    return ((_moves - 1) % 3);
  }
}
