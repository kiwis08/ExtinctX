import 'package:extinctx/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesProvider = FutureProvider.autoDispose((ref) async {
  final database = ref.watch(databaseProvider);
  final categories = await database.getCategories();
  return categories;
});
