import 'package:chatapp/services/auth/auth_gate.dart';
import 'package:chatapp/services/auth/auth_survice.dart';
import 'package:chatapp/componants/my_textField.dart';
import 'package:chatapp/screens/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});
  void logIn(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService
          .signInWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .whenComplete(
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AuthGate()),
                (Route<dynamic> route) => false),
          );
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  "Error",
                ),
                content: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                size: 70,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Welcom Back, you've been missed ",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 16),
              ),
              const SizedBox(
                height: 50,
              ),
              TextFieldWidget(
                allowPadding: true,
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                allowPadding: true,
                hintText: "Password",
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () async => await login(context),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: Center(child: Text("Login")),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member ? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                        (Route<dynamic> route) => false),
                    child: Text(
                      "Register mow ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService
          .signInWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .whenComplete(
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AuthGate()),
                (Route<dynamic> route) => false),
          );
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  "Error",
                ),
                content: Text(e.toString()),
              ));
    }
  }
}
