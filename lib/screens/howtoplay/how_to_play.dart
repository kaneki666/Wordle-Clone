import 'package:flutter/material.dart';
import 'package:wordle/theme/theme.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> word1 = [
      'W',
      'E',
      'A',
      'R',
      'Y',
    ];
    List<String> word2 = ['P', 'I', 'L', 'L', 'S'];
    List<String> word3 = ['V', 'A', 'G', 'U', 'E'];
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: EdgeInsets.only(
              left: WordleTheme.paddingM, right: WordleTheme.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: WordleTheme.paddingXL,
              ),
              SizedBox(
                width: size.width - 30,
                child: Row(
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
                      "How To Play",
                      style: WordleTheme.headerText,
                    ),
                    Icon(
                      Icons.leaderboard,
                      color: WordleTheme.greyColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: WordleTheme.paddingXL,
              ),
              RichText(
                text: TextSpan(
                  text: "Guess the ",
                  style: WordleTheme.textInfo,
                  children: [
                    TextSpan(
                      text: "WORD ",
                      style: WordleTheme.textInfoBold,
                    ),
                    TextSpan(
                      text: "in 6 tries.",
                      style: WordleTheme.textInfo,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: WordleTheme.paddingL,
              ),
              Text(
                "Each guess must bea valid 5 letters word. Hit the enter button to submit.",
                style: WordleTheme.textInfo,
              ),
              SizedBox(
                height: WordleTheme.paddingL,
              ),
              Text(
                "After each guess, the color of the tiles will change to show how close your guess was to the word.",
                style: WordleTheme.textInfo,
              ),
              SizedBox(
                height: WordleTheme.paddingM,
              ),
              Divider(
                color: WordleTheme.greyColor,
                thickness: 2,
              ),
              SizedBox(
                height: 50,
                width: size.width,
                child: ListView.builder(
                  itemCount: word1.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: index == 0
                            ? WordleTheme.blockCorrect
                            : WordleTheme.blockDefault,
                        child: Center(
                          child: Text(
                            word1[index],
                            style: WordleTheme.wordTextHowTo,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: WordleTheme.paddingM,
              ),
              RichText(
                text: TextSpan(
                  text: "The letter ",
                  style: WordleTheme.textInfo,
                  children: [
                    TextSpan(
                      text: "W ",
                      style: WordleTheme.textInfoBold,
                    ),
                    TextSpan(
                      text: "is in the word and correct spot.",
                      style: WordleTheme.textInfo,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: WordleTheme.paddingM,
              ),
              SizedBox(
                height: 50,
                width: size.width,
                child: ListView.builder(
                  itemCount: word2.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: index == 1
                            ? WordleTheme.blockWrong
                            : WordleTheme.blockDefault,
                        child: Center(
                          child: Text(
                            word2[index],
                            style: WordleTheme.wordTextHowTo,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: WordleTheme.paddingM,
              ),
              RichText(
                text: TextSpan(
                  text: "The letter ",
                  style: WordleTheme.textInfo,
                  children: [
                    TextSpan(
                      text: "I ",
                      style: WordleTheme.textInfoBold,
                    ),
                    TextSpan(
                      text: "is in the word but in the wrong spot.",
                      style: WordleTheme.textInfo,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: WordleTheme.paddingM,
              ),
              SizedBox(
                height: 50,
                width: size.width,
                child: ListView.builder(
                  itemCount: word3.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: index == 3
                            ? WordleTheme.greyColor
                            : WordleTheme.blockDefault,
                        child: Center(
                          child: Text(
                            word3[index],
                            style: WordleTheme.wordTextHowTo,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: WordleTheme.paddingM,
              ),
              RichText(
                text: TextSpan(
                  text: "The letter ",
                  style: WordleTheme.textInfo,
                  children: [
                    TextSpan(
                      text: "U ",
                      style: WordleTheme.textInfoBold,
                    ),
                    TextSpan(
                      text: "is not in the word in any spot.",
                      style: WordleTheme.textInfo,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: WordleTheme.paddingM,
              ),
              Divider(
                color: WordleTheme.greyColor,
                thickness: 2,
              ),
              SizedBox(
                height: WordleTheme.paddingM,
              ),
              RichText(
                text: TextSpan(
                  text: "A new ",
                  style: WordleTheme.textInfo,
                  children: [
                    TextSpan(
                      text: "WORD ",
                      style: WordleTheme.textInfoBold,
                    ),
                    TextSpan(
                      text: "will be available each day!",
                      style: WordleTheme.textInfo,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
