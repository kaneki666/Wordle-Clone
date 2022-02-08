import 'package:flutter/material.dart';
import 'package:wordle/screens/howtoplay/how_to_play.dart';
import 'package:wordle/screens/stats/stats.dart';
import 'package:wordle/theme/theme.dart';

class GameHeader extends StatelessWidget {
  const GameHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned(
      top: 25,
      child: SizedBox(
        width: size.width - 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HowToPlayScreen(),
                ),
              ),
              child: Icon(
                Icons.help_outline,
                color: WordleTheme.greyColor,
              ),
            ),
            Text(
              "WORDLE",
              style: WordleTheme.headerText,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatsScreen(),
                ),
              ),
              child: Icon(
                Icons.leaderboard,
                color: WordleTheme.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
