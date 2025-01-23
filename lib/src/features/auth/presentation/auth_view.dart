import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:unn_grading/src/features/auth/presentation/widgets/login_tab.dart';
import 'package:unn_grading/src/features/auth/presentation/widgets/register_tab.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (p, c) => p is AuthLoggedOut && c is AuthLoggedIn,
          listener: (context, state) => Navigator.of(context).pop(),
        ),
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (p, c) {
            try {
              return (p as AuthLoggedOut).authPage !=
                  (c as AuthLoggedOut).authPage;
            } catch (e) {
              return false;
            }
          },
          listener: (context, state) {
            pageController.animateToPage(
              (state as AuthLoggedOut).authPage,
              duration: Durations.medium1,
              curve: Curves.easeOut,
            );
          },
        ),
      ],
      child: Dialog(
        insetPadding: const EdgeInsets.all(40),
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: LayoutBuilder(builder: (context, consts) {
          return Row(
            children: [
              if (consts.maxWidth > 500) const Expanded(child: _BGView()),
              Expanded(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        PageView(
                          // allowImplicitScrolling: true,
                          controller: pageController,
                          children: const [RegisterWidget(), LoginWidget()],
                          onPageChanged: (value) {
                            context.read<AuthBloc>().add(
                                  SwitchLoginType(value),
                                );
                          },
                        ),
                        if (state.status is RequestLoading)
                          const AbsorbPointer(
                            child: ColoredBox(
                              color: Colors.black26,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _BGView extends StatelessWidget {
  const _BGView();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        Image(
          image: AssetImage('assets/images/login_bg.jpg'),
          fit: BoxFit.cover,
        ),
        // Image(image: AssetImage('')),
      ],
    );
  }
}
