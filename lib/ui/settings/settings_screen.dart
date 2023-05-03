import 'package:extinctx/providers/auth_provider.dart';
import 'package:extinctx/providers/database_provider.dart';
import 'package:extinctx/providers/user_provider.dart';
import 'package:extinctx/ui/common_widgets.dart';
import 'package:extinctx/ui/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final db = ref.watch(databaseProvider);
    final auth = ref.watch(authProvider);
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/settings.png'), fit: BoxFit.cover),
      ),
      child: user.when(data: (data) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("Ajustes",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.white)),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Nombre de usuario",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: RoundedTextFormField(
                                  controller: _usernameController,
                                  labelText: "Nombre de usuario",
                                  fillColor: Color(0xFFD9D9D9),
                                  borderRadius: 20,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await db.updateUsername(
                                        data.id, _usernameController.text);
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: e.toString(),
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white);
                                  }
                                },
                                child: const Text("Actualizar"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await auth.signOut();
                                },
                                child: const Text("Cerrar sesión"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
      }, error: (error, _) {
        return Center(
          child: Text(error.toString()),
        );
      }, loading: () {
        return Center(child: Lottie.asset('assets/organic-loading.json'));
      }),
    );
  }
}
