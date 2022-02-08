import 'package:flutter/material.dart';
import 'package:wordle/theme/theme.dart';

class PopUpWidget extends StatelessWidget {
  const PopUpWidget({
    Key? key,
    required this.isPopupShowed,
    required this.popUpColor,
    required this.popUpMsg,
  }) : super(key: key);

  final bool isPopupShowed;

  final Color? popUpColor;
  final String popUpMsg;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      top: isPopupShowed ? 100 : -200,
      child: Container(
        height: 70,
        width: size.width * .8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WordleTheme.paddingL),
          color: popUpColor!,
          boxShadow: [
            BoxShadow(
              color: popUpColor!.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            popUpMsg == "Signing Up. Please wait."
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                popUpMsg,
                style: WordleTheme.popupText,
              ),
            )
          ],
        ),
      ),
    );
  }
}
