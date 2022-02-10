import 'dart:math';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:wordle/components/game_finished_popup.dart';
import 'package:wordle/components/pop_up.dart';
import 'package:wordle/screens/game/components/game_header.dart';
import 'package:http/http.dart' as http;
import 'package:wordle/theme/theme.dart';
import 'package:wordle/utils/data.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List<String>> guessedWords = [[]];
  List<List<Color>> tilesColors = [[]];
  List<List<String>> tilesShare = [[]];

  int activeRow = 0;
  bool isPopUpshowed = false;
  bool gameFinished = false;
  bool solved = false;
  Color popUpColor = Colors.redAccent;
  String msg = '';
  String word = '';

  double angle = 0;

  saveDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    IO.Socket socket = IO.io(api_url, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect(); //connect the Socket.IO Client to the Server

    //SOCKET EVENTS
    // --> listening for connection
    socket.on('connect', (data) {
      socket.emit('saveuser', androidInfo.androidId);
    });
    socket.on('sendword', (data) {
      setState(() {
        word = data;
      });
    });
  }

  getCurrentWordArr() {
    int numberOfGuessedWords = guessedWords.length;
    return guessedWords[numberOfGuessedWords - 1];
  }

  getCurrentCollorArr() {
    int numberOfGuessedWords = tilesColors.length;
    return tilesColors[numberOfGuessedWords - 1];
  }

  getCurrentTilesShareArr() {
    int numberOfGuessedWords = tilesShare.length;
    return tilesShare[numberOfGuessedWords - 1];
  }

  updateGuessedWords(letter) {
    List<String> currentWordArr = getCurrentWordArr();
    if (currentWordArr.length < 5) {
      setState(() {
        currentWordArr.add(letter);
      });
    }
  }

  removeGuessedWords() {
    List<String> currentWordArr = getCurrentWordArr();
    if (currentWordArr.isNotEmpty) {
      setState(() {
        currentWordArr.removeLast();
      });
    }
  }

  getTileColor(String letter, int index) {
    List<Color> currentColor = getCurrentCollorArr();
    List<String> currentTilesShare = getCurrentTilesShareArr();
    bool isCorrectLetter = word.contains(letter);

    if (!isCorrectLetter) {
      setState(() {
        currentColor.add(WordleTheme.blockDefault);
        currentTilesShare.add('⬛');
      });
    } else {
      String letterInThatPosition = word[index];
      bool isCorrectPosition = letter == letterInThatPosition;

      if (isCorrectPosition) {
        setState(() {
          currentColor.add(WordleTheme.blockCorrect);
          currentTilesShare.add('🟩');
        });
      } else {
        setState(() {
          currentColor.add(WordleTheme.blockWrong);
          currentTilesShare.add('🟨');
        });
      }
    }
  }

  handleWordSubmit() async {
    if (!gameFinished) {
      List<String> currentWordArr = await getCurrentWordArr();

      if (currentWordArr.length < 5) {
        setState(() {
          isPopUpshowed = true;
          msg = 'Not enough letters';
        });
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            isPopUpshowed = false;
            msg = '';
          });
        });
      } else {
        String currentWord = currentWordArr.join("");

        var res = await http.get(Uri.parse(
            'https://api.wordnik.com/v4/word.json/${currentWord.toLowerCase()}/definitions?limit=1&includeRelated=false&useCanonical=false&includeTags=false&api_key=c8foz6t403jwjipol5hgu0t1vabxwsu51j1vsx68ddwpk8ryq'));

        if (res.statusCode == 404) {
          setState(() {
            isPopUpshowed = true;
            popUpColor = Colors.redAccent;
            msg = 'Not in word list';
          });
          Future.delayed(const Duration(milliseconds: 2000), () {
            setState(() {
              isPopUpshowed = false;
              msg = '';
            });
          });
        } else if (res.statusCode == 200) {
          for (int i = 0; i < currentWord.length; i++) {
            await getTileColor(currentWordArr[i], i);
          }
          setState(() {
            angle = (angle + pi) % (2 * pi);
          });

          Future.delayed(const Duration(milliseconds: 400), () {
            setState(() {
              angle = 0;
            });
          });
          if (currentWord == word) {
            setState(() {
              isPopUpshowed = true;
              popUpColor = Colors.greenAccent;
              msg = 'Congrats';
              gameFinished = true;
              solved = true;
            });
            Future.delayed(const Duration(milliseconds: 2000), () {
              setState(() {
                isPopUpshowed = false;
                msg = '';
              });
            });
          }
          if (guessedWords.length == 6) {
            setState(() {
              isPopUpshowed = true;
              popUpColor = Colors.redAccent;
              msg = 'Failed word is $word';
              activeRow = 6;
              gameFinished = true;
            });
            Future.delayed(const Duration(milliseconds: 5000), () {
              setState(() {
                isPopUpshowed = false;
                msg = '';
              });
            });
          }
          if (guessedWords.length != 6) {
            guessedWords.add([]);
            tilesColors.add([]);
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
  }

  @override
  void initState() {
    super.initState();
    saveDeviceInfo();
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
          child: word == ''
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent,
                  ),
                )
              : Stack(
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
                      top: size.height * 0.12,
                      child: SizedBox(
                        height: size.height * .09,
                        width: size.width * 0.75,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
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
                                builder:
                                    (BuildContext context, double val, __) {
                                  //here we will change the isBack val so we can change the content of the card

                                  return Transform(
                                    //let's make the card flip by it's center
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(1, 3, 0.001)
                                      ..rotateX(activeRow == 1 ? val : 0),
                                    child: Container(
                                      color: tilesColors[0].length > index
                                          ? tilesColors[0][index]
                                          : WordleTheme.blockDefault,
                                      child: Center(
                                        child: AnimatedScale(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          scale: guessedWords[0].length > index
                                              ? 1
                                              : 0,
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
                      top: size.height * 0.208,
                      child: SizedBox(
                        height: size.height * .09,
                        width: size.width * 0.75,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
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
                                builder:
                                    (BuildContext context, double val, __) {
                                  //here we will change the isBack val so we can change the content of the card

                                  return Transform(
                                    //let's make the card flip by it's center
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(1, 3, 0.001)
                                      ..rotateX(activeRow == 2 ? val : 0),
                                    child: Container(
                                      color: activeRow > 0
                                          ? tilesColors[1].length > index
                                              ? tilesColors[1][index]
                                              : WordleTheme.blockDefault
                                          : WordleTheme.blockDefault,
                                      child: Center(
                                        child: AnimatedScale(
                                          duration:
                                              const Duration(milliseconds: 300),
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
                      top: size.height * 0.296,
                      child: SizedBox(
                        height: size.height * .09,
                        width: size.width * 0.75,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
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
                                builder:
                                    (BuildContext context, double val, __) {
                                  //here we will change the isBack val so we can change the content of the card

                                  return Transform(
                                    //let's make the card flip by it's center
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(1, 3, 0.001)
                                      ..rotateX(activeRow == 3 ? val : 0),
                                    child: Container(
                                      color: activeRow > 1
                                          ? tilesColors[2].length > index
                                              ? tilesColors[2][index]
                                              : WordleTheme.blockDefault
                                          : WordleTheme.blockDefault,
                                      child: Center(
                                        child: AnimatedScale(
                                          duration:
                                              const Duration(milliseconds: 300),
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
                      top: size.height * 0.384,
                      child: SizedBox(
                        height: size.height * .09,
                        width: size.width * 0.75,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
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
                                builder:
                                    (BuildContext context, double val, __) {
                                  //here we will change the isBack val so we can change the content of the card

                                  return Transform(
                                    //let's make the card flip by it's center
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(1, 3, 0.001)
                                      ..rotateX(activeRow == 4 ? val : 0),
                                    child: Container(
                                      color: activeRow > 2
                                          ? tilesColors[3].length > index
                                              ? tilesColors[3][index]
                                              : WordleTheme.blockDefault
                                          : WordleTheme.blockDefault,
                                      child: Center(
                                        child: AnimatedScale(
                                          duration:
                                              const Duration(milliseconds: 300),
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
                      top: size.height * 0.472,
                      child: SizedBox(
                        height: size.height * .09,
                        width: size.width * 0.75,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
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
                                builder:
                                    (BuildContext context, double val, __) {
                                  //here we will change the isBack val so we can change the content of the card

                                  return Transform(
                                    //let's make the card flip by it's center
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(1, 3, 0.001)
                                      ..rotateX(activeRow == 5 ? val : 0),
                                    child: Container(
                                      color: activeRow > 3
                                          ? tilesColors[4].length > index
                                              ? tilesColors[4][index]
                                              : WordleTheme.blockDefault
                                          : WordleTheme.blockDefault,
                                      child: Center(
                                        child: AnimatedScale(
                                          duration:
                                              const Duration(milliseconds: 300),
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
                      top: size.height * 0.56,
                      child: SizedBox(
                        height: size.height * .09,
                        width: size.width * 0.75,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
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
                                builder:
                                    (BuildContext context, double val, __) {
                                  //here we will change the isBack val so we can change the content of the card

                                  return Transform(
                                    //let's make the card flip by it's center
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(1, 3, 0.001)
                                      ..rotateX(activeRow == 6 ? val : 0),
                                    child: Container(
                                      color: activeRow > 4
                                          ? tilesColors[5].length > index
                                              ? tilesColors[5][index]
                                              : WordleTheme.blockDefault
                                          : WordleTheme.blockDefault,
                                      child: Center(
                                        child: AnimatedScale(
                                          duration:
                                              const Duration(milliseconds: 300),
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
                              height: ((size.width - WordleTheme.paddingM * 2) /
                                      10) +
                                  15,
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
                                        height: ((size.width -
                                                    WordleTheme.paddingM * 2) /
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
                                right: ((size.width -
                                            WordleTheme.paddingM * 2 -
                                            60) /
                                        10) /
                                    2,
                                left: ((size.width -
                                            WordleTheme.paddingM * 2 -
                                            60) /
                                        10) /
                                    2,
                              ),
                              child: SizedBox(
                                height:
                                    ((size.width - WordleTheme.paddingM * 2) /
                                            10) +
                                        15,
                                width:
                                    size.width - WordleTheme.paddingM * 2 - 30,
                                child: ListView.builder(
                                  itemCount: alphabets2.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        updateGuessedWords(alphabets2[index]);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
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
                                              alphabets2[index],
                                              style: WordleTheme.keybordText,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ((size.width - WordleTheme.paddingM * 2) /
                                      10) +
                                  15,
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
                                                          WordleTheme.paddingM *
                                                              2) /
                                                      10) +
                                                  15,
                                              width: ((size.width -
                                                          WordleTheme.paddingM *
                                                              2 -
                                                          60) /
                                                      10) +
                                                  30,
                                              decoration: BoxDecoration(
                                                color: WordleTheme.buttonColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        WordleTheme
                                                            .borderRadiusS),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  alphabets3[index],
                                                  style:
                                                      WordleTheme.keybordText,
                                                ),
                                              ),
                                            ),
                                          )
                                        : alphabets3[index] == "DEL"
                                            ? GestureDetector(
                                                onTap: removeGuessedWords,
                                                child: Container(
                                                  height: ((size.width -
                                                              WordleTheme
                                                                      .paddingM *
                                                                  2) /
                                                          10) +
                                                      15,
                                                  width: ((size.width -
                                                              WordleTheme
                                                                      .paddingM *
                                                                  2 -
                                                              60) /
                                                          10) +
                                                      10,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        WordleTheme.buttonColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            WordleTheme
                                                                .borderRadiusS),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.backspace,
                                                      color:
                                                          WordleTheme.textColor,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  updateGuessedWords(
                                                      alphabets3[index]);
                                                },
                                                child: Container(
                                                  height: ((size.width -
                                                              WordleTheme
                                                                      .paddingM *
                                                                  2) /
                                                          10) +
                                                      15,
                                                  width: (size.width -
                                                          WordleTheme.paddingM *
                                                              2 -
                                                          60) /
                                                      10,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        WordleTheme.buttonColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            WordleTheme
                                                                .borderRadiusS),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      alphabets3[index],
                                                      style: WordleTheme
                                                          .keybordText,
                                                    ),
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
                    gameFinished
                        ? GameFinishedPopUpWidget(
                            tilesShare: tilesShare,
                            solved: solved,
                            solvedIn: guessedWords.length == 6
                                ? guessedWords.length
                                : guessedWords.length - 1)
                        : Container(),
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
