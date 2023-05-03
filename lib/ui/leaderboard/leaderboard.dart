import 'package:extinctx/providers/leaderboard_provider.dart';
import 'package:extinctx/ui/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboard = ref.watch(leaderboardProvider);
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/leaderboard.png'), fit: BoxFit.cover),
      ),
      child: leaderboard.when(data: (data) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBar(),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Puntaje",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    color: Colors.white.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: index == 0
                                ? const Icon(
                                    Icons.star,
                                    color: Colors.yellowAccent,
                                  )
                                : null,
                            title: Text(
                              data[index].name,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: index == 0
                                      ? Colors.yellowAccent
                                      : Colors.black),
                            ),
                            trailing: Text(
                              data[index].score.toString(),
                              style: TextStyle(
                                  fontSize: 24,
                                  color: index == 0
                                      ? Colors.yellowAccent
                                      : Colors.black),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }, error: (error, st) {
        return Center(
          child: Text(error.toString()),
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
