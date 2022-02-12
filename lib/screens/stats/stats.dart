// ignore_for_file: division_optimization

import 'package:flutter/material.dart';
import 'package:wordle/models/user.dart';
import 'package:wordle/screens/stats/components/guess_distribution.dart';
import 'package:wordle/screens/stats/components/stats_distribution.dart';
import 'package:wordle/theme/theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key, this.userStat}) : super(key: key);

  final UserModel? userStat;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    int totalGuess = userGuesses.fold(0, (sum, next) => sum + next.number!);
    int winPercentage = (((userStat!.one! +
                    userStat!.two! +
                    userStat!.three! +
                    userStat!.four! +
                    userStat!.five! +
                    userStat!.six!) *
                100) /
            userStat!.played!)
        .toInt();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            left: WordleTheme.paddingM, right: WordleTheme.paddingM),
        child: userStat != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: WordleTheme.paddingXL,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: WordleTheme.greyColor,
                        ),
                      ),
                      Text(
                        "STATISTICS",
                        style: WordleTheme.headerText,
                      ),
                      Icon(
                        Icons.help_outline,
                        color: WordleTheme.greyColor,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: WordleTheme.paddingL,
                  ),
                  Center(
                    child: SizedBox(
                      width: 60 * 3,
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          StatsDistribution(
                              number: userStat!.played!, keyVal: 'Played'),
                          StatsDistribution(
                              number: winPercentage, keyVal: "Win %"),
                          StatsDistribution(
                            number: userStat!.maxstreak!,
                            keyVal: "Current Streak",
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "GUESS DISTRIBUTION",
                      style: WordleTheme.wordTextHowTo,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: SizedBox(
                      width: 400,
                      height: 500,
                      child: ListView(
                        children: [
                          GuessDistribution(
                              number: userStat!.one!,
                              played: userStat!.played!,
                              keyVal: "1"),
                          GuessDistribution(
                              number: userStat!.two!,
                              played: userStat!.played!,
                              keyVal: "2"),
                          GuessDistribution(
                              number: userStat!.three!,
                              played: userStat!.played!,
                              keyVal: "3"),
                          GuessDistribution(
                              number: userStat!.four!,
                              played: userStat!.played!,
                              keyVal: "4"),
                          GuessDistribution(
                              number: userStat!.five!,
                              played: userStat!.played!,
                              keyVal: "5"),
                          GuessDistribution(
                              number: userStat!.six!,
                              played: userStat!.played!,
                              keyVal: "6"),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}
