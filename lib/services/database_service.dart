import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extinctx/model/animal.dart';
import 'package:extinctx/model/category.dart';
import 'package:extinctx/model/quiz.dart';
import 'package:extinctx/model/user.dart';
import 'package:extinctx/model/user_score.dart';

class DatabaseService {
  final firestore = FirebaseFirestore.instance;

  final usersCollection = FirebaseFirestore.instance.collection('users');
  final quizzesCollection = FirebaseFirestore.instance.collection('quizzes');
  final categoriesCollection =
      FirebaseFirestore.instance.collection('categories');
  final animalsCollection = FirebaseFirestore.instance.collection('animals');

  Stream<User> getUser(String id) {
    final snapshots = usersCollection.doc(id).snapshots();
    final user = snapshots.map((event) => User.fromMap(event.data()!));
    return user;
  }

  Future<void> addQuizResult(String userId, QuizResult quizResult) async {
    await usersCollection.doc(userId).update({
      'quizHistory': FieldValue.arrayUnion([quizResult.toMap()])
    });
  }

  Future<List<Category>> getCategories() async {
    final categories = await categoriesCollection.get();
    List<Category> categoriesList = [];
    for (final doc in categories.docs) {
      final animals = doc.data()['animals'];
      List<Animal> animalsList = [];
      for (final id in animals) {
        final animal = await getAnimal(id);
        animalsList.add(animal);
      }
      final category = Category(
          id: doc.id,
          name: doc.data()['name'] as String,
          animals: animalsList,
          image: doc.data()['image']);
      categoriesList.add(category);
    }
    return categoriesList;
  }

  Future<Animal> getAnimal(String id) async {
    final animals = await animalsCollection.doc(id).get();
    final quizId = animals.data()!['quiz'] as String;
    final quiz = await quizzesCollection.doc(quizId).get();
    String description = animals.data()!['description'] as String;
    return Animal(
        id: animals.id,
        name: animals.data()!['name'] as String,
        description: description.replaceAll("\\n ", "\n\n"),
        image: animals.data()!['image'] as String,
        quiz: Quiz.fromMap(quiz.data() as Map<String, dynamic>));
  }

  Future<Quiz> getQuiz(String id) async {
    final quiz = await quizzesCollection.doc(id).get();
    return Quiz.fromMap(quiz.data() as Map<String, dynamic>);
  }

  Stream<List<UserScore>> getLeaderboard() {
    final snapshots = usersCollection.snapshots();
    return snapshots.map((event) {
      List<UserScore> usersList = [];
      for (final doc in event.docs) {
        final user = User.fromMap(doc.data());
        usersList.add(UserScore(name: user.name, score: user.totalScore));
      }
      usersList.sort((a, b) => b.score.compareTo(a.score));
      return usersList;
    });
  }

  Future<void> createUser(String id, String name, String email) async {
    await usersCollection.doc(id).set({
      'name': name,
      'id': id,
      'email': email,
      'quizHistory': [],
    });
  }

  Future<void> updateUsername(String id, String name) async {
    if (name.isEmpty) return Future.error("Nombre no puede estar vacío");
    await usersCollection.doc(id).update({
      'name': name,
    });
  }

  Future<Animal> getAnimalByQuiz(String quizId) async {
    final animal =
        await animalsCollection.where('quiz', isEqualTo: quizId).get();
    return getAnimal(animal.docs.first.id);
  }

  Future<List<Animal>> getUnresolvedAnimals(User user) async {
    final quizzes = await quizzesCollection.get();
    List<Animal> animalsList = [];
    const limit = 5;
    int i = 0;
    for (final doc in quizzes.docs) {
      if (i >= limit) break;
      final quiz = Quiz.fromMap(doc.data());
      if (!user.finishedQuiz(quiz.id)) {
        final animal = await getAnimalByQuiz(quiz.id);
        animalsList.add(animal);
        i++;
      }
    }
    return animalsList;
  }
}
