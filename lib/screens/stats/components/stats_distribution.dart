import 'package:flutter/material.dart';
import 'package:wordle/theme/theme.dart';

class StatsDistribution extends StatelessWidget {
  const StatsDistribution(
      {Key? key, required this.number, required this.keyVal})
      : super(key: key);
  final int number;
  final String keyVal;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: WordleTheme.statsNumber,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 60,
          child: Text(
            keyVal,
            style: WordleTheme.statsText,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
