import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictactoe/game_button.dart';
import 'package:tictactoe/custom_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<GameButton> buttonsList;
  var player1;
  var player2;
  var activePlayer;
  bool autoPlayMode = false;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    player1 = [];
    player2 = [];
    activePlayer = 1;

    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red;
        activePlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = "O";
        gb.bg = Colors.black;
        player2.add(gb.id);
        activePlayer = 1;
      }
      gb.enabled = false;

      int winner = checkWinner();
      if (winner == -1) {
        if (buttonsList.every((p) => p.text != "")) {
          showDialog(
            context: context,
            builder: (_) => CustomDialog(
              "Game Tied",
              "Press the reset button to start again",
              resetGame,
            ),
          );
        } else {
          if (autoPlayMode && activePlayer == 2) {
            autoPlay();
          }
        }
      }
    });
  }

  void autoPlay() {
    var emptyCells = [];
    var list = List.generate(9, (i) => i + 1);
    for (var cellID in list) {
      if (!(player1.contains(cellID) || player2.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }

    if (emptyCells.isNotEmpty) {
      var r = Random();
      var randIndex = r.nextInt(emptyCells.length);
      var cellID = emptyCells[randIndex];
      int i = buttonsList.indexWhere((p) => p.id == cellID);

      setState(() {
        buttonsList[i].text = "O";
        buttonsList[i].bg = Colors.black;
        buttonsList[i].enabled = false;
        player2.add(cellID);
        activePlayer = 1;
      });
    }

    int winner = checkWinner();
    if (winner == -1 && buttonsList.every((p) => p.text != "")) {
      showDialog(
        context: context,
        builder: (_) => CustomDialog(
          "Game Tied",
          "Press the reset button to start again",
          resetGame,
        ),
      );
    }
  }

  int checkWinner() {
    var winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog("Player 1 won",
                "Press the reset button to start again", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog("Player 2 won",
                "Press the reset button to start again", resetGame));
      }
    }
    return winner;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 9.0,
                mainAxisSpacing: 9.0,
              ),
              itemCount: buttonsList.length,
              itemBuilder: (context, i) => SizedBox(
                width: 100.0,
                height: 100.0,
                child: ElevatedButton(
                  onPressed: buttonsList[i].enabled
                      ? () => playGame(buttonsList[i])
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8.0),
                    primary: buttonsList[i].bg,
                  ),
                  child: Text(
                    buttonsList[i].text,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: resetGame,
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              padding: const EdgeInsets.all(20.0),
            ),
            child: Text(
              "Reset",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("AutoPlay Mode"),
              Switch(
                value: autoPlayMode,
                onChanged: (value) {
                  setState(() {
                    autoPlayMode = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
