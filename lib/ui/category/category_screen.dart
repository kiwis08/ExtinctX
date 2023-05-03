import 'package:extinctx/model/category.dart';
import 'package:extinctx/providers/router_rovider.dart';
import 'package:extinctx/ui/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/${category.image}.png'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(category.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white)),
                Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 1.5),
                      itemCount: category.animals.length,
                      itemBuilder: (context, index) {
                        final animal = category.animals[index];
                        return GestureDetector(
                            onTap: () {
                              router.pushNamed('animal', extra: animal);
                            },
                            child: Hero(
                              tag: animal.id,
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(animal.image),
                                        fit: BoxFit.fill,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.4),
                                            BlendMode.darken)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: RoundedBackgroundText(
                                          animal.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white70,
                                          ),
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.8),
                                          outerRadius: 20,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
