// ignore_for_file: public_member_api_docs, sort_constructors_first

class XOPieceModel {
  int? index;
  String sample;
  XOPieceModel({
    this.index,
    required this.sample,
  });

  static const String xSample = 'X';
  static const String oSample = 'O';
  static const String noSample = '-';
}
