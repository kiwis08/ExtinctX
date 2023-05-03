import 'package:extinctx/providers/auth_provider.dart';
import 'package:extinctx/providers/database_provider.dart';
import 'package:extinctx/ui/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _registrationEmailController = TextEditingController();
  final _registrationPasswordController = TextEditingController();
  final _registrationUsernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final db = ref.watch(databaseProvider);
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/category_1.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Image.asset(
                "assets/extinctx_logo.png",
                height: 150,
              ),
              const SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Bienvenido",
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    "Inicia sesión para continuar",
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RoundedTextFormField(
                  controller: _emailController,
                  labelText: 'Correo',
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RoundedTextFormField(
                  controller: _passwordController,
                  labelText: 'Contraseña',
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await auth.signIn(
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                  child: const Text("Iniciar sesión"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              // Button that pops up registration bottom sheet that asks for email, password and username
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30))),
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery
                                  .of(context)
                                  .viewInsets
                                  .bottom),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: SizedBox(
                              child: Form(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Registrarse",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20),
                                    RoundedTextFormField(
                                      controller: _registrationEmailController,
                                      labelText: 'Correo',
                                      fillColor: Colors.grey[200],
                                      prefixIcon:
                                      const Icon(Icons.email_outlined),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Ingresa tu correo';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    RoundedTextFormField(
                                      controller:
                                      _registrationPasswordController,
                                      labelText: 'Contraseña',
                                      fillColor: Colors.grey[200],
                                      prefixIcon:
                                      const Icon(Icons.lock_outline),
                                      obscure: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Ingresa tu contraseña';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    RoundedTextFormField(
                                      controller:
                                      _registrationUsernameController,
                                      labelText: 'Nombre',
                                      fillColor: Colors.grey[200],
                                      prefixIcon:
                                      const Icon(Icons.person_outline),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Ingresa tu nombre';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (_registrationEmailController
                                            .text.isEmpty ||
                                            _registrationPasswordController
                                                .text.isEmpty ||
                                            _registrationUsernameController
                                                .text.isEmpty) {
                                          return;
                                        }
                                        try {
                                          final user = await auth.signUp(
                                            _registrationEmailController.text,
                                            _registrationPasswordController
                                                .text,
                                          );
                                          await db.createUser(
                                              user.uid,
                                              _registrationUsernameController
                                                  .text,
                                              user.email!);
                                        } catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.toString(),
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      },
                                      child: const Text("Registrarse"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text("Registrarse"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
