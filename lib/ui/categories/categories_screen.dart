import 'package:extinctx/providers/categories_provider.dart';
import 'package:extinctx/providers/router_rovider.dart';
import 'package:extinctx/ui/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final router = ref.watch(routerProvider);
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/categories.png'), fit: BoxFit.cover),
      ),
      child: categories.when(data: (data) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Categorias",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 2 / 3),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final category = data[index];
                      return GestureDetector(
                          onTap: () {
                            router.pushNamed('category', extra: category);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        category.animals.first.image),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.4),
                                        BlendMode.darken)),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${category.animals.length}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RoundedBackgroundText(
                                    category.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white70,
                                    ),
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.8),
                                    outerRadius: 20,
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ),
              ),
            ],
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
    );
  }
}
