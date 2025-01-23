import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/features/auth/domain/auth_repo.dart';
import 'package:unn_grading/src/features/auth/presentation/bloc/auth_bloc.dart';

const _heightSpacing = SizedBox(height: 11);

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final roleTEC = TextEditingController();
  final usernameTEC = TextEditingController();
  final passwordTEC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    roleTEC.dispose();
    usernameTEC.dispose();
    passwordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello There!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              _heightSpacing,
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameTEC,
                      decoration: const InputDecoration(hintText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Username required';
                        return null;
                      },
                    ),
                    _heightSpacing,
                    TextFormField(
                      controller: passwordTEC,
                      decoration: const InputDecoration(hintText: 'Password'),
                      validator: (value) {
                        if (value!.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    _heightSpacing,
                    TextFormField(
                      controller: roleTEC,
                      decoration: const InputDecoration(hintText: 'Role'),
                    ),
                  ],
                ),
              ),
              _heightSpacing,
              ElevatedButton(
                child: const Text('Register'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(AuthRegisterIn(
                          data: RegisterData(
                            username: usernameTEC.text,
                            password: passwordTEC.text,
                            role: roleTEC.text,
                          ),
                        ));
                  }
                },
              ),
              const Text('or', textAlign: TextAlign.center),
              OutlinedButton(
                child: const Text('Log In'),
                onPressed: () {
                  context.read<AuthBloc>().add(const SwitchLoginType(1));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
