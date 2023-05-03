import 'package:extinctx/model/animal.dart';
import 'package:extinctx/model/user.dart';
import 'package:extinctx/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unresolvedAnimalsProvider =
    FutureProvider.family.autoDispose<List<Animal>, User>((ref, user) async {
  final db = ref.watch(databaseProvider);
  final quizzes = await db.getUnresolvedAnimals(user);
  return quizzes;
});
