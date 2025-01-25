import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/presentation/bloc/auth_bloc.dart';

const _heightSpacing = SizedBox(height: 11);

class SetNewPasswordWidget extends StatefulWidget {
  const SetNewPasswordWidget({super.key});

  @override
  State<SetNewPasswordWidget> createState() => _SetNewPasswordWidgetState();
}

class _SetNewPasswordWidgetState extends State<SetNewPasswordWidget> {
  final passwordTEC = TextEditingController();
  final otpTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordTEC.dispose();
    otpTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetState) Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reset Your Password!',
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
                      controller: otpTEC,
                      decoration: const InputDecoration(
                        hintText: 'Your password-reset OTP',
                      ),
                      validator: (value) {
                        if (value!.length < 4) return '4-digit OTP is required';

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordTEC,
                      decoration: const InputDecoration(
                        hintText: 'Your new password',
                      ),
                      validator: (value) {
                        if (value!.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                  ],
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
                        : const Text('Reset Password'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthSetNewPasswprdReset(
                              otp: otpTEC.text,
                              newPassword: passwordTEC.text,
                            ));
                      }
                    },
                  );
                },
              ),
              _heightSpacing,
              const Text('or', textAlign: TextAlign.center),
              _heightSpacing,
              TextButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
