import 'package:blur/blur.dart';
import 'package:extinctx/model/animal.dart';
import 'package:extinctx/providers/router_rovider.dart';
import 'package:extinctx/providers/user_provider.dart';
import 'package:extinctx/ui/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimalScreen extends ConsumerWidget {
  const AnimalScreen({super.key, required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/category_1.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: CustomAppBar(),
          body: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Hero(
                      tag: animal.id,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2.7,
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
                            children: [
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // Animal's image as circle
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                        child: Image.network(
                                          animal.image,
                                          height: 42,
                                          width: 42,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        animal.name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ).frosted(
                                  frostColor: const Color(0xff8EF0EA),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        color: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              Text(
                                animal.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                animal.description,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF39B086)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(16)),
                  ),
                  onPressed: () {
                    router.pushNamed('quiz', extra: animal);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Quiz",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.white)
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
