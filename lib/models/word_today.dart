class WordTodayModel {
  final String? time;
  final String? word;
  const WordTodayModel({this.time, this.word});

  WordTodayModel.fromJson(Map<String, dynamic> json)
      : this(
          time: json['time']! as String,
          word: json['word']! as String,
        );
}
