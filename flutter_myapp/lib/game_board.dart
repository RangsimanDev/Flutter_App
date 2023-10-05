import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/componets/dead_piece.dart';
import 'package:flutter_myapp/componets/piece.dart';
import 'package:flutter_myapp/componets/square.dart';
import 'helper_fun.dart';
import 'home.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChessPiece?>> board;

  //ถ้าไม่มีการเลือกชิ้นส่วนให้เป็นค่า null
  ChessPiece? selectedPiece;

  //The row index of the selected piece
  //ค่าเริ่มต้น -1 แสดงว่ายังไม่มีการเลือกชิ้นส่วนใด
  int selectedRow = -1;

  //The col index of the selected piece
  //ค่าเริ่มต้น -1 แสดงว่ายังไม่มีการเลือกชิ้นส่วนใด
  int selectedCol = -1;

  // A list of valid moves for currently selected piece
  List<List<int>> validMoves = [];

  //เก็บหมากที่สีขาวกินดำ
  List<ChessPiece> whitePieceTaken = [];

  //เก็บหมากที่สีดำกินขาว
  List<ChessPiece> blackPieceTaken = [];

  //เก็บค่าว่าเป็นรอบของฝั่งไหน
  bool isWhiteTurn = true;

  //ตรวจสอบ king
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  //เริ่มต้นเกม โดย เป็น null หรือ ไม่มีชิ้นบนกระดาน
  void _initializeBoard() {
    late List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    // Place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: false,
          imagesPath: 'lib/Images/pawn.png');
      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: true,
          imagesPath: 'lib/Images/pawn.png');
    }
    // Place rooks
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagesPath: 'lib/Images/rook.png');
    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagesPath: 'lib/Images/rook.png');
    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagesPath: 'lib/Images/rook.png');
    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagesPath: 'lib/Images/rook.png');

    // Place knight
    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagesPath: 'lib/Images/knight.png');
    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagesPath: 'lib/Images/knight.png');
    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagesPath: 'lib/Images/knight.png');
    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagesPath: 'lib/Images/knight.png');

    // Place bishops
    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagesPath: 'lib/Images/bishop.png');
    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagesPath: 'lib/Images/bishop.png');
    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagesPath: 'lib/Images/bishop.png');
    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagesPath: 'lib/Images/bishop.png');

    // Place queen
    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagesPath: 'lib/Images/queen.png');
    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagesPath: 'lib/Images/queen.png');

    // Place kings
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imagesPath: 'lib/Images/king.png');
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imagesPath: 'lib/Images/king.png');

    board = newBoard;
  }

  //Use selected a piece
  void pieceSelected(int row, int col) {
    setState(() {
      // No place has been selected yet, this is the first selection
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }

      // There is a piece already selected, but can select another one of piece
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }

      //ถ้ามีการเลือกหมาก และ มีการกดที่ช่องของการเดิน, ให้เดิน
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }

      //if a piece is selected, คำนวณหาค่า การ ย้ายหมาก
      validMoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

  //กฎการเดินของหมาก
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    //เก็บค่าทิศทางที่แตกต่างกันตามสี
    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        // เบี้ย เดินได้ทีละ 1 ช่อง ไปข้างหน้า
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        //เบี้ยสามารถเคลื่อน 2 ช่องไปข้างหน้าได้หากอยู่ในตำแหน่งเริ่มต้น
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        //เบี้ยสามารถฆ่าได้ในแนวทแยง
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        break;
      case ChessPieceType.rook:
        // ทิศทางแนวตั้งและแนวนอน
        var direction = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
        ];

        for (var direction in direction) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); //kill
              }
              break; //stop loop
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        //ม้า เดินเป็นรูปตัว L ได้รอบตัว ข้ามหมากตัวอื่นได้ รวม 8 วิธี
        var knightMoves = [
          [-2, -1], //up 2 left 1
          [-2, 1], //up 2 right 1
          [-1, -2], //up 1 left 2
          [-1, 2], //up 1 right 2
          [1, -2], //down 1 left 2
          [1, 2], //down 1 right 2
          [2, -1], //down 2 left 1
          [2, 1], //down 2 right 1
        ];

        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];

          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue; //stop loop
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        //เดินได้ทีละ 1 ช่องในแนวทแยงทั้งด้านหน้าและด้านหลัง รวม 4 วิธี
        var direction = [
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in direction) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        //สามารถเดินได้ในแนวตั้ง แนวนอน และแนวทแยง 8 ทิศทาง
        var direction = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in direction) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        //คิงเดินได้หนึ่งช่องในทุกทิศทาง
        var direction = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in direction) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      default:
    }
    return candidateMoves;
  }

  //คำนวณค่าจริงของการย้าย
  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    //หลังจากสร้างการเคลื่อนไหวทั้งหมดแล้ว ให้กรองสิ่งที่จะส่งผลให้เกิดการตรวจสอบออก
    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];

        //จำลองการเคลื่อนไหวในอนาคตเพื่อดูว่าปลอดภัยหรือไม่
        if (simulatedMoveInSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  //จำลองการเคลื่อนไหวในอนาคตเพื่อดูว่าปลอดภัยหรือไม่ (ไม่ทำให้ king ของคุณเองถูกโจมตี)
  bool simulatedMoveInSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    //Save the current board state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    //หากชิ้นส่วนนั้นเป็น king ให้บันทึกตำแหน่งปัจจุบันไว้และอัปเดตเป็นชิ้นใหม่
    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      //อัพเดทตำแหน่ง
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    //simulate the move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    //ตรวจสอบว่า king ของเราถูกโจมตีหรือไม่
    bool kingInCheck = isKingInCheck(piece.isWhite);

    //restore board to og
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    //ถ้าชิ้นส่วนนั้นเป็น king ก็ให้คืนตำแหน่งและตำแหน่งนั้น
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }

    //if king is check = ture, คือ ไม่ปลอดภัย safe move = false
    return !kingInCheck;
  }

  // Move Piece
  void movePiece(int newRow, int newCol) {
    //if the new spot has an enemy piece
    if (board[newRow][newCol] != null) {
      //เพิ่มรายการที่ยัดได้ลงไปที่ list
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePieceTaken.add(capturedPiece);
      } else {
        blackPieceTaken.add(capturedPiece);
      }
    }

    //Check if the piece being moved in a king
    if (selectedPiece!.type == ChessPieceType.king) {
      //อัพเดท ตำแหน่ง King
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    //Move the piece and clear the old spot
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    //ดูว่า king ฝั่งไหนจะถูกกิน
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    //Clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    //Chack mate
    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("CHECK MATE!"),
          actions: [
            //play again button
            TextButton(onPressed: resetGame, child: const Text("PLAY AGAIN")),
          ],
        ),
      );
    }

    //เปลี่ยน รอบ
    isWhiteTurn = !isWhiteTurn;
  }

  //ตรวจสอบ king?
  bool isKingInCheck(bool isWhiteKing) {
    //เก็บค่าตำแหน่งของ king
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;

    //เช็คว่ามีตัวที่จะกิน king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        //ข้ามช่องสี่เหลี่ยมว่างๆ และหมากที่มีสีเดียวกับ king
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValiMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        //ตรวจสอบว่าตำแหน่ง king อยู่ในการเคลื่อนไหวที่ถูกต้องหรือไม่
        if (pieceValiMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  //CHECK MATE
  bool isCheckMate(bool isWhiteKing) {
    //ถ้า king ไม่ได้ถูกคุม, ไม่ต้องเช็ค
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }

    //หากมีการขยับหมากอย่างน้อย 1 ครั้ง, ไม่ต้องเช็ค
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValiMoves =
            calculateRealValidMoves(i, j, board[i][j], true);

        //หากชิ้นส่วนนี้มีการเคลื่อนไหวที่ถูกต้อง, ไม่ต้องเช็ค
        if (pieceValiMoves.isNotEmpty) {
          return false;
        }
      }
    }

    // หากไม่ตรงตามเงื่อนไขข้างต้น,ก็ไม่มีการดำเนินการตามกฎ
    //Check mate!
    return true;
  }

  //RESET GAME
  void resetGame() {
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    whitePieceTaken.clear();
    blackPieceTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    isWhiteTurn = true;
    setState(() {});
  }

  //rematch
  void reMatch() {
    _initializeBoard();
    checkStatus = false;
    whitePieceTaken.clear();
    blackPieceTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    isWhiteTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        backgroundColor: const Color.fromARGB(255, 255, 108, 108),
        color: const Color.fromARGB(169, 195, 0, 0),
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          if (index == 1) {
            reMatch();
          } else if (index == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHome(),
                ));
          }
        },
        items: const [
          Icon(
            Icons.home,
            size: 50,
          ),
          Icon(
            Icons.refresh,
            size: 50,
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 108, 108),
      body: Column(
        children: <Widget>[
          //White Piece Take
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: GridView.builder(
              itemCount: whitePieceTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                  imagesPath: whitePieceTaken[index].imagesPath, isWhite: true),
            ),
          )),

          // Game Status

          Text(
            checkStatus ? "CHECK!" : "",
            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          ),

          //CHESS BOARD
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: 8 * 8,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) {
                //get row and column position of the square
                int row = index ~/ 8;
                int col = index % 8;

                //เช็คว่ามีการถูกเลือกในช่อง
                bool isSelected = selectedRow == row && selectedCol == col;

                //เช็คว่ามีการเคลื่อนที่
                bool isValiMove = false;
                for (var position in validMoves) {
                  //เปรียบเทียบ row and col
                  if (position[0] == row && position[1] == col) {
                    isValiMove = true;
                  }
                }

                return Square(
                  isWhite: isWhite(index),
                  piece: board[row][col],
                  isSelected: isSelected,
                  isValidMove: isValiMove,
                  onTap: () => pieceSelected(row, col),
                );
              },
            ),
          ),

          //Black Piece Taken
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: GridView.builder(
                itemCount: blackPieceTaken.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) => DeadPiece(
                    imagesPath: blackPieceTaken[index].imagesPath,
                    isWhite: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
