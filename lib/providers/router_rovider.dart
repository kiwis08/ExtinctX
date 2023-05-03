import 'package:extinctx/navigation/app_router.dart';
import 'package:extinctx/navigation/login_state.dart';
import 'package:extinctx/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authChanges = ref.watch(authStateChangesProvider);
  final user = authChanges.asData?.value;
  final LoginState loginState = LoginState(user != null);
  return AppRouter(loginState: loginState).router;
});
