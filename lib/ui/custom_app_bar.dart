import 'package:extinctx/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key, this.title, this.height}) : super(key: key);

  final Widget? title;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;
    return Padding(
      padding: const EdgeInsets.only(top: 42.0),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (context.canPop()) ...[
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: title,
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Color(0xFF75FFD6),
                      ),
                      Text(
                        user?.totalScore.toString() ?? "NA",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.go("/settings");
                  },
                  icon: Image.asset("assets/profile.png"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
