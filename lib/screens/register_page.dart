import 'package:chatapp/services/auth/auth_gate.dart';
import 'package:chatapp/services/auth/auth_survice.dart';
import 'package:chatapp/componants/my_textField.dart';
import 'package:chatapp/screens/login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Future<void> register(BuildContext context) async {
    final authService = AuthService();
    if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  "Error",
                ),
                content: Text("Password not matched"),
              ));
    } else {
      try {
        await authService
            .signUpWithEmailAndPassword(
                _emailController.text, _passwordController.text, context)
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
                "Let's create an account for you ",
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
                height: 10,
              ),
              TextFieldWidget(
                allowPadding: true,
                hintText: "Confirm Password",
                obscureText: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () async => await register(context),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: Center(child: Text("Register")),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false),
                    child: Text(
                      "Login now",
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
}
