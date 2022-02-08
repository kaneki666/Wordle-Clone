import 'package:flutter/material.dart';
import 'package:wordle/models/user.dart';
import 'package:wordle/theme/theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    int totalGuess = userGuesses.fold(0, (sum, next) => sum + next.number!);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            left: WordleTheme.paddingM, right: WordleTheme.paddingM),
        child: Column(
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
                width: 60 * userStats.length.toDouble(),
                height: 100,
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
                height: 500,
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
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
