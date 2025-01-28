import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:unn_grading/src/core/constants/app_color.dart';
import 'package:unn_grading/src/core/utils/helpers.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:unn_grading/src/features/auth/presentation/auth_view.dart';
import 'package:unn_grading/src/features/results/presentation/bloc/edit_result_bloc/edit_result_bloc.dart';
import 'package:unn_grading/src/features/results/domain/models/result_tab.dart';
import 'package:unn_grading/src/features/results/presentation/bloc/result_tab_bloc/result_tab_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/bloc/save_result_bloc/save_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/search/open_result_bloc/open_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/widgets/custom_text_fields.dart';
import 'package:unn_grading/src/features/results/presentation/widgets/title_bar.dart';
import 'package:unn_grading/src/features/side_bar/widgets/side_bar.dart';

part '../widgets/grading_section.dart';
part '../widgets/header_section.dart';

class PlutoGridGradingPage extends StatefulWidget {
  const PlutoGridGradingPage({super.key});

  @override
  State<PlutoGridGradingPage> createState() => _PlutoGridGradingPageState();
}

class _PlutoGridGradingPageState extends State<PlutoGridGradingPage> {
  @override
  void initState() {
    context.read<AuthBloc>().add(GetLoginState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ResultTabBloc()),
          BlocProvider(create: (context) => ResultTabBloc()),
          BlocProvider(create: (context) => EditResultBloc()),
          BlocProvider(create: (context) => SaveResultBloc(context.read())),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (p, c) => p is AuthLoggedIn,
              listener: (context, state) {
                if (state is AuthLoggedOut) {
                  context.read<EditResultBloc>().add(
                        const SetEditResultStateEvent(),
                      );
                  context.read<ResultTabBloc>().add(
                        const CloseAllResultTabsEvent(),
                      );
                }
              },
            ),
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (p, c) => p is! AuthLoggedOut,
              listener: (context, state) {
                if (state is AuthLoggedOut) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const LoginView(),
                  );
                }
              },
            ),

            BlocListener<SaveResultBloc, SaveResultState>(
              listener: (context, state) {
                if (state.status is RequestError) {
                  final message = (state.status as RequestError).message;
                  if (message.isNotEmpty) showSnackBar(context, message);
                }
              },
            ),
            BlocListener<SaveResultBloc, SaveResultState>(
              listener: (context, state) {
                if (state is ResultSaveState &&
                    state.status is RequestSuccess) {
                  context.read<ResultTabBloc>().add(
                        UpdateResultTabDataEvent(state.tab),
                      );
                }
              },
            ),

            // When the Tab changes, update the [EditResultBloc]'s state to
            // corresponding Tab State
            BlocListener<ResultTabBloc, ResultTabState>(
              listenWhen: (p, c) => p.getCurrentTab != c.getCurrentTab,
              listener: (context, state) {
                final editState = state.editResultStates[state.getCurrentTab];
                if (editState != null) {
                  context.read<EditResultBloc>().add(
                        SetEditResultStateEvent(state: editState),
                      );
                }
              },
            ),

            //Save new [EditResultState] instance in [ResultTabBloc]'s memory
            //when modified.
            //Consider to only save when Tab is changed
            BlocListener<EditResultBloc, EditResultState>(
              listener: (context, state) {
                context.read<ResultTabBloc>().add(
                      CacheEditResultStateEvent(state: state),
                    );
              },
            ),
            BlocListener<OpenResultBloc, OpenResultState>(
              listener: (context, state) {
                if (state is ResultOpenedState) {
                  context.read<ResultTabBloc>().add(
                        OpenResultTabEvent(state.data),
                      );
                  context.read<EditResultBloc>().add(
                        OpenResultDataEvent(state.data),
                      );
                }
              },
            ),
          ],
          child: const TitleBarWidget(
            child: MySideBar(
              width: 32,
              expandedWidth: 112,
              theme: MySideBarTheme(iconTheme: IconThemeData(size: 16)),
              child: _EditResultPage(),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditResultPage extends StatelessWidget {
  const _EditResultPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [BoxShadow(blurRadius: 1, color: Colors.black26)],
      ),
      child: BlocSelector<ResultTabBloc, ResultTabState, ResultTab?>(
        selector: (state) => state.getCurrentTab,
        builder: (context, getCurrentTab) {
          if (getCurrentTab != null) {
            return _ResultTabSection(tab: getCurrentTab);
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<ResultTabBloc>().add(const NewResultTabEvent());
              },
              child: const Text('+ New', style: TextStyle(fontSize: 24)),
            ),
          );
        },
      ),
    );
  }
}

class _ResultTabSection extends StatelessWidget {
  const _ResultTabSection({required this.tab});
  final ResultTab tab;

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        _HeaderSection(),
        SizedBox(height: 16),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: _GradingSection(),
          ),
        ),
      ],
    );
  }
}
