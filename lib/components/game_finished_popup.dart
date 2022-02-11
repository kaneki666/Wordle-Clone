import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordle/components/tommrrow_clock.dart';
import 'package:wordle/models/user.dart';
import 'package:wordle/theme/theme.dart';

class GameFinishedPopUpWidget extends StatelessWidget {
  const GameFinishedPopUpWidget({
    Key? key,
    this.tilesShare,
    this.solved,
    this.solvedIn,
  }) : super(key: key);
  final List<List<String>>? tilesShare;
  final bool? solved;
  final int? solvedIn;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String d = "Wordle 1 $solvedIn/6\n\n";

    for (int i = 0; i < tilesShare![0].length; i += 5) {
      d = d + tilesShare![0].sublist(i, i + 5).join('') + "\n";
    }

    int totalGuess = userGuesses.fold(0, (sum, next) => sum + next.number!);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      top: size.height * 0.1,
      child: Container(
        height: size.height * 0.7,
        width: size.width * .9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WordleTheme.paddingL),
          color: WordleTheme.bgSecondary,
          boxShadow: [
            BoxShadow(
              color: WordleTheme.bgSecondary.withOpacity(0.7),
              spreadRadius: 7,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: WordleTheme.paddingM, right: WordleTheme.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: WordleTheme.paddingL,
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
                  width: 60 * userStats.length.toDouble(),
                  height: 80,
                  child: ListView.builder(
                    itemCount: userStats.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Text(
                            userStats[index].number.toString(),
                            style: WordleTheme.statsNumber,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              userStats[index].key!,
                              style: WordleTheme.statsText,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      );
                    },
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
                  height: 200,
                  child: ListView.builder(
                    itemCount: userGuesses.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Text(
                              userGuesses[index].key!,
                              style: WordleTheme.guessKey,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: userGuesses[index].number! > 0
                                  ? ((200 *
                                              userGuesses[index]
                                                  .number!
                                                  .toDouble()) /
                                          totalGuess) +
                                      20
                                  : 20,
                              color: WordleTheme.blockDefault,
                              child: Row(
                                mainAxisAlignment:
                                    userGuesses[index].number! > 0
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userGuesses[index].number.toString(),
                                    style: WordleTheme.guessNumber,
                                  ),
                                  userGuesses[index].number! > 0
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
                    },
                  ),
                ),
              ),
              SizedBox(
                width: size.width * .8,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * .4,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "NEXT WORDLE",
                            style: WordleTheme.shareButton,
                          ),
                          const TomorrowCountdown(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * .3,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          Share.share(d);
                        },
                        child: Text(
                          "Share",
                          style: WordleTheme.shareButton,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              WordleTheme.blockCorrect),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
