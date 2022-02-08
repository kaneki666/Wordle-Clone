import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordle/components/pop_up.dart';
import 'package:wordle/screens/game/components/game_header.dart';
import 'package:wordle/screens/howtoplay/how_to_play.dart';
import 'package:wordle/screens/stats/stats.dart';
import 'package:wordle/theme/theme.dart';
import 'package:wordle/utils/data.dart';
import 'package:flip_card/flip_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List<String>> guessedWords = [[]];
  List<List<Color>> tilesColors = [[]];

  int activeRow = 0;
  bool isPopUpshowed = false;
  bool gameFinished = false;
  Color popUpColor = Colors.redAccent;
  String msg = '';
  String word = 'QWERT';
  Color tileColor = WordleTheme.blockDefault;
  double angle = 0;

  getCurrentWordArr() {
    int numberOfGuessedWords = guessedWords.length;
    return guessedWords[numberOfGuessedWords - 1];
  }

  getCurrenColorArr() {
    int numberOfGuessedWords = tilesColors.length;
    return tilesColors[numberOfGuessedWords - 1];
  }

  updateGuessedWords(letter) {
    List<String> currentWordArr = getCurrentWordArr();
    if (currentWordArr.length < 5) {
      setState(() {
        currentWordArr.add(letter);
      });
    }
  }

  getTileColor(String letter, int index) {
    List<Color> currentColor = getCurrenColorArr();
    bool isCorrectLetter = word.contains(letter);

    if (!isCorrectLetter) {
      setState(() {
        currentColor.add(WordleTheme.blockDefault);
      });
    }

    String letterInThatPosition = word[index];
    bool isCorrectPosition = letter == letterInThatPosition;

    if (isCorrectPosition) {
      setState(() {
        currentColor.add(WordleTheme.blockCorrect);
      });
    } else {
      setState(() {
        currentColor.add(WordleTheme.blockWrong);
      });
    }
  }

  handleWordSubmit() {
    if (!gameFinished) {
      List<String> currentWordArr = getCurrentWordArr();

      if (currentWordArr.length < 5) {
        // setState(() {
        //   isPopUpshowed = true;
        //   msg = 'Not enough letters';
        // });
      } else {
        setState(() {
          angle = (angle + pi) % (2 * pi);
        });
        Future.delayed(const Duration(milliseconds: 400), () {
          setState(() {
            angle = 0;
          });
        });
        String currentWord = currentWordArr.join("");
        for (int i = 0; i < currentWord.length; i++) {
          getTileColor(currentWordArr[i], i);
        }
        if (currentWord == "QWERT") {
          setState(() {
            isPopUpshowed = true;
            popUpColor = Colors.greenAccent;
            msg = 'Congrats';
            gameFinished = true;
          });
        }
        if (guessedWords.length == 6) {
          setState(() {
            isPopUpshowed = true;
            popUpColor = Colors.redAccent;
            msg = 'Failed';
            activeRow = 6;
            gameFinished = true;
          });
        }
        if (guessedWords.length != 6) {
          guessedWords.add([]);
          tilesColors.add([]);
          setState(() {});
        }
        setState(() {
          if (activeRow < 6) {
            setState(() {
              activeRow = activeRow + 1;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: EdgeInsets.only(
              left: WordleTheme.paddingM, right: WordleTheme.paddingM),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              const GameHeader(),
              Positioned(
                top: 60,
                child: SizedBox(
                  width: size.width - WordleTheme.paddingM * 2,
                  child: Divider(
                    color: WordleTheme.greyColor,
                    thickness: 2,
                  ),
                ),
              ),
              Positioned(
                top: 80,
                child: SizedBox(
                  height: (size.width - WordleTheme.paddingM * 2 + 5) * 1,
                  width: size.width - WordleTheme.paddingM * 2,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: angle),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                          builder: (BuildContext context, double val, __) {
                            //here we will change the isBack val so we can change the content of the card

                            return Transform(
                              //let's make the card flip by it's center
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(1, 3, 0.001)
                                ..rotateX(activeRow == 1 ? val : 0),
                              child: Container(
                                height:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                width:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                color: tilesColors[0].length > index
                                    ? tilesColors[0][index]
                                    : WordleTheme.blockDefault,
                                child: Center(
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 300),
                                    scale:
                                        guessedWords[0].length > index ? 1 : 0,
                                    child: Text(
                                      guessedWords[0].length > index
                                          ? guessedWords[0][index]
                                          : '',
                                      style: WordleTheme.wordText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              Positioned(
                top: 155,
                child: SizedBox(
                  height: (size.width - WordleTheme.paddingM * 2 + 5) * 1,
                  width: size.width - WordleTheme.paddingM * 2,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: angle),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                          builder: (BuildContext context, double val, __) {
                            //here we will change the isBack val so we can change the content of the card

                            return Transform(
                              //let's make the card flip by it's center
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(1, 3, 0.001)
                                ..rotateX(activeRow == 2 ? val : 0),
                              child: Container(
                                height:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                width:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                color: activeRow > 0
                                    ? tilesColors[1].length > index
                                        ? tilesColors[1][index]
                                        : WordleTheme.blockDefault
                                    : WordleTheme.blockDefault,
                                child: Center(
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 300),
                                    scale: activeRow > 0
                                        ? guessedWords[1].length > index
                                            ? 1
                                            : 0
                                        : 0,
                                    child: Text(
                                      activeRow > 0
                                          ? guessedWords[1].length > index
                                              ? guessedWords[1][index]
                                              : ''
                                          : '',
                                      style: WordleTheme.wordText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              Positioned(
                top: 230,
                child: SizedBox(
                  height: (size.width - WordleTheme.paddingM * 2 + 5) * 1,
                  width: size.width - WordleTheme.paddingM * 2,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: angle),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                          builder: (BuildContext context, double val, __) {
                            //here we will change the isBack val so we can change the content of the card

                            return Transform(
                              //let's make the card flip by it's center
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(1, 3, 0.001)
                                ..rotateX(activeRow == 3 ? val : 0),
                              child: Container(
                                height:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                width:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                color: activeRow > 1
                                    ? tilesColors[2].length > index
                                        ? tilesColors[2][index]
                                        : WordleTheme.blockDefault
                                    : WordleTheme.blockDefault,
                                child: Center(
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 300),
                                    scale: activeRow > 1
                                        ? guessedWords[2].length > index
                                            ? 1
                                            : 0
                                        : 0,
                                    child: Text(
                                      activeRow > 1
                                          ? guessedWords[2].length > index
                                              ? guessedWords[2][index]
                                              : ''
                                          : '',
                                      style: WordleTheme.wordText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              Positioned(
                top: 305,
                child: SizedBox(
                  height: (size.width - WordleTheme.paddingM * 2 + 5) * 1,
                  width: size.width - WordleTheme.paddingM * 2,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: angle),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                          builder: (BuildContext context, double val, __) {
                            //here we will change the isBack val so we can change the content of the card

                            return Transform(
                              //let's make the card flip by it's center
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(1, 3, 0.001)
                                ..rotateX(activeRow == 4 ? val : 0),
                              child: Container(
                                height:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                width:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                color: activeRow > 2
                                    ? tilesColors[3].length > index
                                        ? tilesColors[3][index]
                                        : WordleTheme.blockDefault
                                    : WordleTheme.blockDefault,
                                child: Center(
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 300),
                                    scale: activeRow > 2
                                        ? guessedWords[3].length > index
                                            ? 1
                                            : 0
                                        : 0,
                                    child: Text(
                                      activeRow > 2
                                          ? guessedWords[3].length > index
                                              ? guessedWords[3][index]
                                              : ''
                                          : '',
                                      style: WordleTheme.wordText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              Positioned(
                top: 380,
                child: SizedBox(
                  height: (size.width - WordleTheme.paddingM * 2 + 5) * 1,
                  width: size.width - WordleTheme.paddingM * 2,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: angle),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                          builder: (BuildContext context, double val, __) {
                            //here we will change the isBack val so we can change the content of the card

                            return Transform(
                              //let's make the card flip by it's center
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(1, 3, 0.001)
                                ..rotateX(activeRow == 5 ? val : 0),
                              child: Container(
                                height:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                width:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                color: activeRow > 3
                                    ? tilesColors[4].length > index
                                        ? tilesColors[4][index]
                                        : WordleTheme.blockDefault
                                    : WordleTheme.blockDefault,
                                child: Center(
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 300),
                                    scale: activeRow > 3
                                        ? guessedWords[4].length > index
                                            ? 1
                                            : 0
                                        : 0,
                                    child: Text(
                                      activeRow > 3
                                          ? guessedWords[4].length > index
                                              ? guessedWords[4][index]
                                              : ''
                                          : '',
                                      style: WordleTheme.wordText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              Positioned(
                top: 455,
                child: SizedBox(
                  height: (size.width - WordleTheme.paddingM * 2 + 5) * 1,
                  width: size.width - WordleTheme.paddingM * 2,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: angle),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                          builder: (BuildContext context, double val, __) {
                            //here we will change the isBack val so we can change the content of the card

                            return Transform(
                              //let's make the card flip by it's center
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(1, 3, 0.001)
                                ..rotateX(activeRow == 6 ? val : 0),
                              child: Container(
                                height:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                width:
                                    (size.width - WordleTheme.paddingM * 2) / 5,
                                color: activeRow > 4
                                    ? tilesColors[5].length > index
                                        ? tilesColors[5][index]
                                        : WordleTheme.blockDefault
                                    : WordleTheme.blockDefault,
                                child: Center(
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 300),
                                    scale: activeRow > 4
                                        ? guessedWords[5].length > index
                                            ? 1
                                            : 0
                                        : 0,
                                    child: Text(
                                      activeRow > 4
                                          ? guessedWords[5].length > index
                                              ? guessedWords[5][index]
                                              : ''
                                          : '',
                                      style: WordleTheme.wordText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: size.height * 0.3,
                  width: size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height:
                            ((size.width - WordleTheme.paddingM * 2) / 10) + 15,
                        width: size.width - WordleTheme.paddingM * 2,
                        child: ListView.builder(
                          itemCount: alphabets1.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                updateGuessedWords(alphabets1[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  height:
                                      ((size.width - WordleTheme.paddingM * 2) /
                                              10) +
                                          15,
                                  width: (size.width -
                                          WordleTheme.paddingM * 2 -
                                          60) /
                                      10,
                                  decoration: BoxDecoration(
                                    color: WordleTheme.buttonColor,
                                    borderRadius: BorderRadius.circular(
                                        WordleTheme.borderRadiusS),
                                  ),
                                  child: Center(
                                    child: Text(
                                      alphabets1[index],
                                      style: WordleTheme.keybordText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: ((size.width - WordleTheme.paddingM * 2 - 60) /
                                  10) /
                              2,
                          left: ((size.width - WordleTheme.paddingM * 2 - 60) /
                                  10) /
                              2,
                        ),
                        child: SizedBox(
                          height:
                              ((size.width - WordleTheme.paddingM * 2) / 10) +
                                  15,
                          width: size.width - WordleTheme.paddingM * 2 - 30,
                          child: ListView.builder(
                            itemCount: alphabets2.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  height:
                                      ((size.width - WordleTheme.paddingM * 2) /
                                              10) +
                                          15,
                                  width: (size.width -
                                          WordleTheme.paddingM * 2 -
                                          60) /
                                      10,
                                  decoration: BoxDecoration(
                                    color: WordleTheme.buttonColor,
                                    borderRadius: BorderRadius.circular(
                                        WordleTheme.borderRadiusS),
                                  ),
                                  child: Center(
                                    child: Text(
                                      alphabets2[index],
                                      style: WordleTheme.keybordText,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height:
                            ((size.width - WordleTheme.paddingM * 2) / 10) + 15,
                        width: size.width - WordleTheme.paddingM * 2,
                        child: ListView.builder(
                          itemCount: alphabets3.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: alphabets3[index] == "ENTER"
                                  ? GestureDetector(
                                      onTap: handleWordSubmit,
                                      child: Container(
                                        height: ((size.width -
                                                    WordleTheme.paddingM * 2) /
                                                10) +
                                            15,
                                        width: ((size.width -
                                                    WordleTheme.paddingM * 2 -
                                                    60) /
                                                10) +
                                            30,
                                        decoration: BoxDecoration(
                                          color: WordleTheme.buttonColor,
                                          borderRadius: BorderRadius.circular(
                                              WordleTheme.borderRadiusS),
                                        ),
                                        child: Center(
                                          child: Text(
                                            alphabets3[index],
                                            style: WordleTheme.keybordText,
                                          ),
                                        ),
                                      ),
                                    )
                                  : alphabets3[index] == "DEL"
                                      ? Container(
                                          height: ((size.width -
                                                      WordleTheme.paddingM *
                                                          2) /
                                                  10) +
                                              15,
                                          width: ((size.width -
                                                      WordleTheme.paddingM * 2 -
                                                      60) /
                                                  10) +
                                              10,
                                          decoration: BoxDecoration(
                                            color: WordleTheme.buttonColor,
                                            borderRadius: BorderRadius.circular(
                                                WordleTheme.borderRadiusS),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.backspace,
                                              color: WordleTheme.textColor,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: ((size.width -
                                                      WordleTheme.paddingM *
                                                          2) /
                                                  10) +
                                              15,
                                          width: (size.width -
                                                  WordleTheme.paddingM * 2 -
                                                  60) /
                                              10,
                                          decoration: BoxDecoration(
                                            color: WordleTheme.buttonColor,
                                            borderRadius: BorderRadius.circular(
                                                WordleTheme.borderRadiusS),
                                          ),
                                          child: Center(
                                            child: Text(
                                              alphabets3[index],
                                              style: WordleTheme.keybordText,
                                            ),
                                          ),
                                        ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopUpWidget(
                isPopupShowed: isPopUpshowed,
                popUpColor: popUpColor,
                popUpMsg: msg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
