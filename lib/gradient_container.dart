import 'package:flutter/material.dart';
import 'dice_roller.dart';

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

class GradientContainer extends StatefulWidget {
  const GradientContainer({super.key});

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer> {
  Color color1 = const Color.fromARGB(255, 33, 5, 109);
  Color color2 = const Color.fromARGB(255, 68, 21, 149);
  String? resultMessage;

  void updateBackground(bool isWin) {
    setState(() {
      if (isWin) {
        color1 = Colors.green.shade700;
        color2 = Colors.green.shade400;
        resultMessage = "You Win!";
      } else {
        color1 = Colors.red.shade700;
        color2 = Colors.red.shade400;
        resultMessage = "You Lose!";
      }
    });
  }

  void resetBackground() {
    setState(() {
      color1 = const Color.fromARGB(255, 33, 5, 109);
      color2 = const Color.fromARGB(255, 68, 21, 149);
      resultMessage = null;
    });
  }

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (resultMessage != null)
              Text(
                resultMessage!,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            DiceRoller(
              onGameEnd: updateBackground,
              onReset: resetBackground,
            ),
          ],
        ),
      ),
    );
  }
}
