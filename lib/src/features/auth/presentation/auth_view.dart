import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/constants/theme.dart';
import 'package:unn_grading/src/core/utils/helpers.dart';
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
        clipBehavior: Clip.hardEdge,
        insetPadding: const EdgeInsets.all(40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Scaffold(
          body: LayoutBuilder(builder: (context, consts) {
            return Row(
              children: [
                if (consts.maxWidth > 500) const Expanded(child: _BGView()),
                Expanded(
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    child: MaterialApp(
                      theme: themeData,
                      debugShowCheckedModeBanner: false,
                      home: Scaffold(
                        body: BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state.status is RequestError) {
                              showSnackBar(
                                context,
                                (state.status as RequestError).message,
                              );
                            } else if (state.status is RequestSuccess) {
                              showSnackBar(
                                context,
                                'Successful',
                                isError: false,
                              );
                            }
                          },
                          builder: (context, state) {
                            return PageView(
                              controller: pageController,
                              children: const [LoginWidget(), RegisterWidget()],
                              onPageChanged: (value) {
                                context.read<AuthBloc>().add(
                                      SwitchLoginType(value),
                                    );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
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
