import 'package:extinctx/providers/user_provider.dart';
import 'package:extinctx/ui/categories/categories_screen.dart';
import 'package:extinctx/ui/leaderboard/leaderboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:extinctx/ui/home/home_screen.dart';
import 'package:extinctx/ui/settings/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class RootScreen extends ConsumerStatefulWidget {
  final String tab;

  const RootScreen({required this.tab, Key? key}) : super(key: key);

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: screens.length, vsync: this, initialIndex: _index);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController.index = _index;
  }

  final screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const LeaderboardScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return user.when(data: (userData) {
      setState(() {
        switch (widget.tab) {
          case "home":
            _index = 0;
            break;
          case "categories":
            _index = 1;
            break;
          case "scoreboard":
            _index = 2;
            break;
          case "settings":
            _index = 3;
            break;
          default:
            _index = 0;
            break;
        }
        _tabController.animateTo(_index);
      });
      return Scaffold(
        extendBody: true,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Principal',
                activeIcon: Icon(Icons.home)),
            BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted_outlined),
                label: 'Categorias',
                activeIcon: Icon(Icons.format_list_bulleted)),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.flag),
                label: 'Puntaje',
                activeIcon: Icon(CupertinoIcons.flag_fill)),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Ajustes',
                activeIcon: Icon(Icons.settings)),
          ],
          currentIndex: _tabController.index,
          onTap: (index) {
            switch (index) {
              case 0:
                context.goNamed("home");
                break;
              case 1:
                context.goNamed("categories");
                break;
              case 2:
                context.goNamed("scoreboard");
                break;
              case 3:
                context.goNamed("settings");
                break;
            }
          },
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: screens,
        ),
      );
    }, error: (error, _) {
      return Center(
        child: Text(error.toString()),
      );
    }, loading: () {
      return Scaffold(
        body: Center(
          child: Lottie.asset('assets/organic-loading.json'),
        ),
      );
    });
  }
}
