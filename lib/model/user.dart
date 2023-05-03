import 'package:extinctx/model/quiz.dart';

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.quizHistory,
  });

  final String id;
  final String name;
  final String email;
  final List<QuizResult> quizHistory;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      quizHistory: (map['quizHistory'] as List<dynamic>)
          .map((e) => QuizResult.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  int get totalScore {
    int total = 0;
    List<QuizResult> quizzes = [];
    // sum all scores, but if a quiz repeats, only count the highest score
    for (final quiz in quizHistory) {
      if (!quizzes.any((element) => element.quizId == quiz.quizId)) {
        quizzes.add(quiz);
        total += quiz.score;
      } else {
        final index =
            quizzes.indexWhere((element) => element.quizId == quiz.quizId);
        if (quiz.score > quizzes[index].score) {
          quizzes[index] = quiz;
          total += quiz.score;
        }
      }
    }
    return total;
  }

  bool finishedQuiz(String id) =>
      quizHistory.any((element) => element.quizId == id);
}
