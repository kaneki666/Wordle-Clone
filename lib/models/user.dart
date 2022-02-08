class StatsModel {
  final int? number;
  final String? key;
  const StatsModel({this.number, this.key});
}

class GuessModel {
  final int? number;
  final String? key;
  const GuessModel({this.number, this.key});
}

List<StatsModel> userStats = [
  const StatsModel(
    number: 3,
    key: "Played",
  ),
  const StatsModel(
    number: 33,
    key: "Wind %",
  ),
  const StatsModel(
    number: 3,
    key: "Current Streak",
  ),
  const StatsModel(
    number: 3,
    key: "Max Streak",
  )
];

List<GuessModel> userGuesses = [
  const GuessModel(
    number: 0,
    key: "1",
  ),
  const GuessModel(
    number: 0,
    key: "2",
  ),
  const GuessModel(
    number: 5,
    key: "3",
  ),
  const GuessModel(
    number: 0,
    key: "4",
  ),
  const GuessModel(
    number: 2,
    key: "5",
  ),
  const GuessModel(
    number: 1,
    key: "6",
  )
];
