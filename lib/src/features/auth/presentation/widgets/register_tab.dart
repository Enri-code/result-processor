import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/constants/theme.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
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
  final departmentTEC = TextEditingController();
  final usernameTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final passwordTEC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool _showPassword = false;

  @override
  void dispose() {
    roleTEC.dispose();
    departmentTEC.dispose();
    usernameTEC.dispose();
    emailTEC.dispose();
    passwordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hello There!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
          _heightSpacing,
          _heightSpacing,
          Flexible(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: usernameTEC,
                      decoration: const InputDecoration(hintText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Username is required';
                        return null;
                      },
                    ),
                    _heightSpacing,
                    TextFormField(
                      controller: emailTEC,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Email is required';
                        return null;
                      },
                    ),
                    _heightSpacing,
                    TextFormField(
                      controller: departmentTEC,
                      decoration: const InputDecoration(hintText: 'Department'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Department is required';
                        return null;
                      },
                    ),
                    _heightSpacing,
                    DropdownButtonFormField(
                      hint: Text(
                        'Role',
                        style: themeData.inputDecorationTheme.hintStyle,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'hod',
                          child: Text('HOD'),
                        ),
                        DropdownMenuItem(
                          value: 'exam_officer',
                          child: Text('Exam Officer'),
                        ),
                        DropdownMenuItem(
                          value: 'lecturer',
                          child: Text('Lecturer'),
                        ),
                      ],
                      onChanged: (value) => roleTEC.text = value!,
                      validator: (value) {
                        if ((value ?? '').isEmpty) return 'Role is required';
                        return null;
                      },
                    ),
                    _heightSpacing,
                    TextFormField(
                      controller: passwordTEC,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() => _showPassword = !_showPassword);
                          },
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if ((value ?? '').length < 8) {
                          return 'Must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          _heightSpacing,
          _heightSpacing,
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return ElevatedButton(
                child: state.status is RequestLoading
                    ? const SizedBox.square(
                        dimension: 16,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const Text('Register'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(AuthRegisterIn(
                          data: RegisterData(
                            username: usernameTEC.text,
                            email: emailTEC.text,
                            department: departmentTEC.text,
                            password: passwordTEC.text,
                            role: roleTEC.text,
                          ),
                        ));
                  }
                },
              );
            },
          ),
          _heightSpacing,
          const Text('or', textAlign: TextAlign.center),
          _heightSpacing,
          OutlinedButton(
            child: const Text('Log In'),
            onPressed: () {
              context.read<AuthBloc>().add(const SwitchLoginType(0));
            },
          ),
        ],
      ),
    );
  }
}
