import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wordle/theme/theme.dart';

class TomorrowCountdown extends StatefulWidget {
  const TomorrowCountdown({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TomorrowCountdownState();
}

class _TomorrowCountdownState extends State<TomorrowCountdown> {
  Timer? _timer;
  DateTime? _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimeChange);
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  void _onTimeChange(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final startOfNextWeek = nextDay(_currentTime!);
    final remaining = startOfNextWeek.difference(_currentTime!);

    final days = remaining.inDays;
    final hours = remaining.inHours - remaining.inDays * 24;
    final minutes = remaining.inMinutes - remaining.inHours * 60;
    final seconds = remaining.inSeconds - remaining.inMinutes * 60;

    final formattedRemaining = '$days : $hours : $minutes : $seconds';

    return Text(
      formattedRemaining,
      style: WordleTheme.shareButton,
    );
  }
}

DateTime nextDay(DateTime time) {
  return DateTime(time.year, time.month, time.day + 1);
}
