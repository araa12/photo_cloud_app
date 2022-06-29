import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_cloud/logic/app_bloc.dart';
import 'package:photo_cloud/logic/app_events.dart';
import 'package:photo_cloud/utils/if_debugging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'alirazaabro908@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: '@Ali12345'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your Paswword',
              ),
              obscureText: true,
            ),
            Center(
              child: MaterialButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  context.read<AppBloc>().add(
                      AppEventRegisterUser(email: email, password: password));
                },
                color: Theme.of(context).primaryColor,
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  context.read<AppBloc>().add(const AppEventGoToLogin());
                },
                child: const Text(
                  'Already Registered ? Login Here ',
                  style: TextStyle(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
