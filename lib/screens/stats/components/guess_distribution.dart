import 'package:flutter/material.dart';
import 'package:wordle/theme/theme.dart';

class GuessDistribution extends StatelessWidget {
  const GuessDistribution({
    Key? key,
    required this.number,
    required this.keyVal,
    required this.played,
  }) : super(key: key);

  final int? number;
  final int? played;
  final String? keyVal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Text(
            keyVal!,
            style: WordleTheme.guessKey,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width:
                number! > 0 ? ((200 * number!.toDouble()) / played!) + 20 : 20,
            color: WordleTheme.blockDefault,
            child: Row(
              mainAxisAlignment: number! > 0
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.center,
              children: [
                Text(
                  number!.toString(),
                  style: WordleTheme.guessNumber,
                ),
                number! > 0
                    ? SizedBox(
                        width: WordleTheme.paddingM,
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
