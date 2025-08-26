import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_event.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login', style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset('assets/images/logo.jpeg'),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),

              ),
              onPressed: () {

                context.read<AuthBloc>().add(
                      AuthLoginRequested(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    );
              },
              child: const Text('Entrar', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}