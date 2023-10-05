import 'package:flutter/material.dart';
import 'package:flutter_myapp/game_board.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 147, 0, 0),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              padding: const EdgeInsets.only(right: 85, left: 85),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 219, 219, 219),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Chess",
                    style: GoogleFonts.bebasNeue(
                      textStyle: const TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                      color: const Color.fromARGB(255, 203, 14, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Game",
                    style: GoogleFonts.bebasNeue(
                      textStyle: const TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                      color: const Color.fromARGB(255, 203, 14, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 3, right: 3),
              padding: const EdgeInsets.only(right: 100, left: 100, top: 50),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 21, 21, 21),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: FloatingActionButton(
                      backgroundColor: const Color.fromARGB(255, 255, 48, 33),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameBoard(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.play_arrow,
                        size: 150,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Text(
                    "Play Game !",
                    style: GoogleFonts.bebasNeue(
                      textStyle: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
