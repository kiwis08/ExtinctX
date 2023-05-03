class Question {
  String question;
  int answer;
  String option1;
  String option2;
  String option3;
  String option4;

  Question(
      {required this.question,
      required this.answer,
      required this.option1,
      required this.option2,
      required this.option3,
      required this.option4});

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
    };
  }
}

class Quiz {
  final String id;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.questions,
  });

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'] as String,
      questions: (map['questions'] as List<dynamic>)
          .map((e) => Question(
                question: e['question'] as String,
                answer: e['answer'] as int,
                option1: e['option1'] as String,
                option2: e['option2'] as String,
                option3: e['option3'] as String,
                option4: e['option4'] as String,
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questions': questions.map((e) => e.toMap()).toList(),
    };
  }
}

class QuizResult {
  final String quizId;
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final DateTime date;

  QuizResult(
      {required this.quizId,
      required this.score,
      required this.date,
      required this.correctAnswers,
      required this.totalQuestions});

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      quizId: map['quizId'] as String,
      score: map['score'] as int,
      date: DateTime.parse(map['date'] as String),
      correctAnswers: map['correctAnswers'] as int,
      totalQuestions: map['totalQuestions'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'score': score,
      'date': date.toIso8601String(),
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
    };
  }
}
