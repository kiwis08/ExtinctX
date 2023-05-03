import 'package:blur/blur.dart';
import 'package:extinctx/model/animal.dart';
import 'package:extinctx/providers/quiz_provider.dart';
import 'package:extinctx/providers/user_provider.dart';
import 'package:extinctx/ui/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:extinctx/ui/home/logo_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final unresolvedAnimals = ref.watch(unresolvedAnimalsProvider(user.value!));
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/main_screen.png'), fit: BoxFit.cover),
      ),
      child: user.when(data: (data) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            height: 100,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Inicio',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white)),
                Text(
                  "Bienvenido ${data.name}",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const LogoCard(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: const Text("Desafios diarios",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              unresolvedAnimals.when(data: (data) {
                return Container(
                  height: MediaQuery.of(context).size.height / 2.7,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemExtent: MediaQuery.of(context).size.width / 1.5,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          context.push('/animal', extra: data[index]);
                        },
                        child: AnimalCard(animal: data[index]),
                      );
                    },
                  ),
                );
              }, error: (error, _) {
                return Center(
                  child: Text(error.toString()),
                );
              }, loading: () {
                return Center(
                  child: Lottie.asset("assets/organic-loading.json"),
                );
              }),
            ],
          ),
        );
      }, error: (error, st) {
        return Center(
          child: Text(error.toString()),
        );
      }, loading: () {
        return Center(
          child: Lottie.asset("assets/organic-loading.json"),
        );
      }),
    );
  }
}

class AnimalCard extends StatelessWidget {
  const AnimalCard({Key? key, required this.animal}) : super(key: key);

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Hero(
        tag: animal.id,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(animal.image),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(animal.name,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 2),
                        child: Icon(
                          Icons.star,
                          color: Color(0xff8EF0EA),
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 2),
                        child: Text(
                          "${animal.quiz.questions.length * 10} puntos",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ).frosted(
                    frostColor: Colors.grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
