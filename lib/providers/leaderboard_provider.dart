import 'package:extinctx/model/user_score.dart';
import 'package:extinctx/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaderboardProvider = StreamProvider.autoDispose<List<UserScore>>((ref) {
  final database = ref.watch(databaseProvider);
  final leaderboard = database.getLeaderboard();
  return leaderboard;
});
