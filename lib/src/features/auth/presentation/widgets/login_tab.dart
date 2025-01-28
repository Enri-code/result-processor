import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:unn_grading/src/features/auth/presentation/widgets/forgot_password_tab.dart';

const _heightSpacing = SizedBox(height: 11);

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final usernameTEC = TextEditingController();
  final passwordTEC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool _showPassword = false;

  @override
  void dispose() {
    usernameTEC.dispose();
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
              'Welcome Back!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
          _heightSpacing,
          _heightSpacing,
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: usernameTEC,
                  decoration: const InputDecoration(
                    hintText: 'Username or Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Username or Email is required';
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
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Password is required';
                    return null;
                  },
                ),
              ],
            ),
          ),
          _heightSpacing,
          RichText(
            text: TextSpan(
              text: 'Forgot Password?',
              style: TextStyle(fontSize: 11.5, color: Colors.blue[900]),
              recognizer: TapGestureRecognizer()..onTap = _onForgotPassword,
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
                    : const Text('Log In'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(AuthLogIn(
                          username: usernameTEC.text,
                          password: passwordTEC.text,
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
            child: const Text('Register'),
            onPressed: () {
              context.read<AuthBloc>().add(const SwitchLoginType(1));
            },
          ),
        ],
      ),
    );
  }

  void _onForgotPassword() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ForgotPasswordWidget(),
    ));
  }
}
