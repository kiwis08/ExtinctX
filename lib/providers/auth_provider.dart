import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:extinctx/services/auth_service.dart';

final authProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateChangesProvider =
    StreamProvider<User?>((ref) => ref.watch(authProvider).authStateChanges());
