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

class GuessesModel {
  final List<dynamic>? word;
  final String? guess;
  final String? time;
  final bool? correct;

  const GuessesModel({this.word, this.guess, this.time, this.correct});
  GuessesModel.fromJson(Map<String, dynamic> json)
      : this(
          word: json['word']! as List<dynamic>,
          guess: json['guess']! as String,
          time: json['time']! as String,
          correct: json['correct']! as bool,
        );
}

class UserModel {
  final String? id;
  final int? played;
  final int? maxstreak;
  final int? one;
  final int? two;
  final int? three;
  final int? four;
  final int? five;
  final int? six;
  final List<GuessesModel>? guesses;
  const UserModel({
    this.id,
    this.played,
    this.maxstreak,
    this.one,
    this.two,
    this.three,
    this.four,
    this.five,
    this.six,
    this.guesses,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id']! as String,
          played: json['played']! as int,
          maxstreak: json['maxstreak']! as int,
          one: json['one']! as int,
          two: json['two']! as int,
          three: json['three']! as int,
          four: json['four']! as int,
          five: json['five']! as int,
          six: json['six']! as int,
          guesses: json["guesses"] != null
              ? json["guesses"]
                  .map<GuessesModel>((guess) => GuessesModel.fromJson(guess))
                  .toList()
              : [],
        );
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
