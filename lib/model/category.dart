import 'animal.dart';

class Category {
  final String id;
  final String name;
  final List<Animal> animals;
  final String image;

  const Category(
      {required this.id,
      required this.name,
      required this.animals,
      required this.image});
}
