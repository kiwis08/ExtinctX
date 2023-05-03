import 'package:extinctx/model/quiz.dart';
import 'package:extinctx/model/user.dart';
import 'package:extinctx/providers/auth_provider.dart';
import 'package:extinctx/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider.autoDispose<User>((ref) {
  final database = ref.watch(databaseProvider);
  final authService = ref.watch(authProvider);
  final authUser = authService.getFirebaseUser();
  final user = database.getUser(authUser!.uid);
  return user;
});
