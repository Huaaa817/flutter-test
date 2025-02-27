import 'dart:math';
import 'package:flutter/material.dart';
import 'styled_text.dart';

final randomizer = Random();

class DiceRoller extends StatefulWidget {
  final void Function(bool) onGameEnd;
  final VoidCallback onReset;

  const DiceRoller({super.key, required this.onGameEnd, required this.onReset});

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<DiceRoller> {
  static const int totalRounds = 5;
  static const int goalScore = 20;
  var currentDiceRoll = 1;
  int currentRound = 0;
  int totalScore = 0;
  List<String> scores = List.filled(totalRounds, "--");

  final List<String> roundNames = ["1st", "2nd", "3rd", "4th", "5th"];

  void rollDice() {
    if (currentRound < totalRounds) {
      setState(() {
        currentDiceRoll = randomizer.nextInt(6) + 1;
        scores[currentRound] = currentDiceRoll.toString();
        totalScore += currentDiceRoll;
        currentRound++;
      });

      if (totalScore >= goalScore) {
        widget.onGameEnd(true);
      } else if (currentRound == totalRounds) {
        widget.onGameEnd(false);
      }
    }
  }

  void resetGame() {
    setState(() {
      currentDiceRoll = 1;
      currentRound = 0;
      totalScore = 0;
      scores = List.filled(totalRounds, "--");
    });

    widget.onReset(); // 通知 GradientContainer 重置背景顏色
  }

  @override
  Widget build(context) {
    bool gameOver = currentRound == totalRounds || totalScore >= goalScore;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your score: $totalScore/$goalScore',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: totalScore / goalScore,
          backgroundColor: Colors.grey,
          color: Colors.green,
          minHeight: 10,
        ),
        const SizedBox(height: 20),

        /// **五局分數直列顯示**
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalRounds, (index) {
            return Expanded(
              child: Column(
                children: [
                  /// **顯示局數名稱**
                  Text(
                    roundNames[index],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),

                  /// **顯示對應的分數**
                  Text(
                    scores[index],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),

        const SizedBox(height: 20),
        Image.asset(
          'assets/images/dice-$currentDiceRoll.png',
          width: 200,
        ),
        const SizedBox(height: 20),

        /// **Roll Dice / Play Again 按鈕**
        TextButton(
          onPressed: gameOver ? resetGame : rollDice,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 28,
            ),
          ),
          child: StyledText(gameOver ? 'Play Again' : 'Roll Dice'),
        ),

        /// **"Chance left" 移到這裡**
        const SizedBox(height: 10),
        Text(
          'Chance left: ${totalRounds - currentRound}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
