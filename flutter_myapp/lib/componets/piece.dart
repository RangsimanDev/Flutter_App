//Enumeration เปรียบเสมือนการ fix ค่าไว้ใช้งาน ซึ่งเป็นการกำหนดค่าไว้ล่วงหน้า
enum ChessPieceType{pawn, rook, knight, bishop, queen, king}

class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  final String imagesPath;

  ChessPiece({
    required this.type,
    required this.isWhite,
    required this.imagesPath
  });
}