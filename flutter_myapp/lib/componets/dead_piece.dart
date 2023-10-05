import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  final String imagesPath;
  final bool isWhite;

  const DeadPiece({
    super.key,
    required this.imagesPath, 
    required this.isWhite
    });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagesPath,
      color: isWhite ? Colors.white : Colors.black,
      );
  }
}
