import 'package:extinctx/model/quiz.dart';

class Animal {
  final String id;
  final String name;
  final String description;
  final String image;
  final Quiz quiz;

  const Animal(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.quiz});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'quiz': quiz.id,
    };
  }
}
