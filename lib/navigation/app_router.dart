import 'package:extinctx/model/animal.dart';
import 'package:extinctx/model/category.dart';
import 'package:extinctx/model/quiz.dart';
import 'package:extinctx/ui/animal/animal_screen.dart';
import 'package:extinctx/ui/category/category_screen.dart';
import 'package:extinctx/ui/quiz/quiz_screen.dart';
import 'package:extinctx/ui/quiz/success_screen.dart';
import 'package:extinctx/ui/root.dart';
import 'package:go_router/go_router.dart';
import 'package:extinctx/navigation/login_state.dart';
import 'package:extinctx/ui/login/login_screen.dart';

class AppRouter {
  AppRouter({required this.loginState});

  final LoginState loginState;

  GoRouter get router => GoRouter(
        routes: [
          GoRoute(
            name: "main",
            path: '/',
            redirect: (context, state) =>
                state.namedLocation("root", params: {'tab': 'home'}),
          ),
          GoRoute(
            name: "login",
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          // GoRoute(
          //   name: "register",
          //   path: '/register',
          //   builder: (context, state) => const RegistrationScreen(),
          // ),
          GoRoute(
            name: "root",
            path: '/root/:tab(home|categories|scoreboard|settings)',
            builder: (context, state) {
              final tab = state.params['tab']!;
              return RootScreen(tab: tab);
            },
          ),
          GoRoute(
            name: "home",
            path: '/home',
            redirect: (context, state) =>
                state.namedLocation("root", params: {'tab': "home"}),
          ),
          GoRoute(
            name: "categories",
            path: '/categories',
            redirect: (context, state) =>
                state.namedLocation("root", params: {'tab': "categories"}),
          ),
          GoRoute(
            name: "scoreboard",
            path: '/scoreboard',
            redirect: (context, state) =>
                state.namedLocation("root", params: {'tab': "scoreboard"}),
          ),
          GoRoute(
            name: "settings",
            path: '/settings',
            redirect: (context, state) =>
                state.namedLocation("root", params: {'tab': "settings"}),
          ),
          GoRoute(
            name: "category",
            path: '/category',
            builder: (context, state) {
              final category = state.extra! as Category;
              return CategoryScreen(
                category: category,
              );
            },
          ),
          GoRoute(
            name: "animal",
            path: '/animal',
            builder: (context, state) {
              final animal = state.extra! as Animal;
              return AnimalScreen(
                animal: animal,
              );
            },
          ),
          GoRoute(
            name: "quiz",
            path: '/quiz',
            builder: (context, state) {
              final animal = state.extra! as Animal;
              return QuizScreen(
                animal: animal,
              );
            },
          ),
          GoRoute(
            name: "success",
            path: '/success',
            builder: (context, state) {
              final result = state.extra! as QuizResult;
              return SuccessScreen(
                result: result,
              );
            },
          ),
        ],
        redirect: (context, state) async {
          final loggingIn = state.location == "/login";
          final creatingAccount = state.location == "/register";
          final loggedIn = loginState.loggedIn;
          if (!loggedIn && !loggingIn && !creatingAccount) return "/login";
          if (loggedIn && (loggingIn || creatingAccount)) return "/";
          return null;
        },
      );
}
