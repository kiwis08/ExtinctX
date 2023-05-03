import 'package:blur/blur.dart';
import 'package:extinctx/model/animal.dart';
import 'package:extinctx/model/quiz.dart';
import 'package:extinctx/model/user.dart';
import 'package:extinctx/providers/database_provider.dart';
import 'package:extinctx/providers/user_provider.dart';
import 'package:extinctx/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({Key? key, required this.animal}) : super(key: key);

  final Animal animal;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int currentQuestion = 0;

  int selectedAnswer = -1;

  int correctAnswers = 0;
  int score = 0;

  bool loading = false;

  Future<void> answerQuestion(int answer, User user, DatabaseService db) async {
    setState(() {
      if (answer == widget.animal.quiz.questions[currentQuestion].answer) {
        correctAnswers++;
        score += 10;
      }
      selectedAnswer = -1;
    });

    if (currentQuestion < widget.animal.quiz.questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      setState(() {
        loading = true;
      });
      final quizResult = QuizResult(
        quizId: widget.animal.quiz.id,
        score: score,
        date: DateTime.now(),
        correctAnswers: correctAnswers,
        totalQuestions: widget.animal.quiz.questions.length,
      );
      try {
        await db.addQuizResult(user.id, quizResult);
        context.go("/success", extra: quizResult);
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Error submitting quiz result: $e",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red.shade300,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final db = ref.watch(databaseProvider);
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/main_screen.png'), fit: BoxFit.cover),
      ),
      child: user.when(data: (data) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.animal.image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Animal's image as circle
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  child: Image.network(
                                    widget.animal.image,
                                    height: 42,
                                    width: 42,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                widget.animal.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ).frosted(
                            frostColor: const Color(0xff8EF0EA),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16),
                  child: SizedBox(
                    height: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: (currentQuestion + 1) /
                            widget.animal.quiz.questions.length,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF39B086)),
                        backgroundColor: Color(0xffD6D6D6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            widget.animal.quiz.questions[currentQuestion]
                                .question,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          child: Container(
                            color: selectedAnswer == 0
                                ? Color(0xFF39B086)
                                : Colors.white.withOpacity(0.8),
                            child: ListTile(
                              title: Text(
                                widget.animal.quiz.questions[currentQuestion]
                                    .option1,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () => setState(() => selectedAnswer = 0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          child: Container(
                            color: selectedAnswer == 1
                                ? Color(0xFF39B086)
                                : Colors.white.withOpacity(0.8),
                            child: ListTile(
                              title: Text(
                                widget.animal.quiz.questions[currentQuestion]
                                    .option2,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () => setState(() => selectedAnswer = 1),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          child: Container(
                            color: selectedAnswer == 2
                                ? Color(0xFF39B086)
                                : Colors.white.withOpacity(0.8),
                            child: ListTile(
                              title: Text(
                                widget.animal.quiz.questions[currentQuestion]
                                    .option3,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () => setState(() => selectedAnswer = 2),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          child: Container(
                            color: selectedAnswer == 3
                                ? Color(0xFF39B086)
                                : Colors.white.withOpacity(0.8),
                            child: ListTile(
                              title: Text(
                                widget.animal.quiz.questions[currentQuestion]
                                    .option4,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () => setState(() => selectedAnswer = 3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (loading) ...[
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF39B086)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(16)),
                      ),
                      onPressed: () async {
                        await answerQuestion(selectedAnswer, data, db);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentQuestion <
                                    widget.animal.quiz.questions.length - 1
                                ? "Siguiente"
                                : "Finalizar",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }, error: (error, st) {
        return const Center(
          child: Text('Error'),
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
