import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_bar/menu_bar.dart';
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
import 'package:unn_grading/src/features/results/presentation/search/widgets/cc_search_dialog.dart';
import 'package:unn_grading/src/features/results/presentation/upload/upload_result_bloc/upload_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/upload/widgets/upload_file.dart';
import 'package:unn_grading/src/features/results/presentation/widgets/custom_text_fields.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ResultTabBloc()),
        BlocProvider(create: (context) => EditResultBloc()),
        BlocProvider(create: (context) => SaveResultBloc(context.read())),
      ],
      child: MultiBlocListener(
        listeners: [
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
          // When the Tab changes, update the [EditResultBloc]'s state to
          // corresponding Tab State
          BlocListener<ResultTabBloc, ResultTabState>(
            listenWhen: (p, c) => p.getCurrentTab != c.getCurrentTab,
            listener: (context, state) {
              final editState = state.editResultStates[state.getCurrentTab];
              context.read<EditResultBloc>().add(
                    SetEditResultStateEvent(state: editState),
                  );
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
        ],
        child: Scaffold(
          body: BlocSelector<ResultTabBloc, ResultTabState, ResultTab?>(
            selector: (state) => state.getCurrentTab,
            builder: (context, tab) {
              return MenuBarWidget(
                barStyle: const MenuStyle(elevation: WidgetStatePropertyAll(1)),
                barButtonStyle: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(32)),
                  textStyle: WidgetStatePropertyAll(
                    TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                menuButtonStyle: const ButtonStyle(
                  iconSize: WidgetStatePropertyAll(14),
                  textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(36)),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
                barButtons: [
                  BarButton(
                    text: const Text('File'),
                    submenu: SubMenu(
                      menuItems: [
                        MenuButton(
                          text: const Text('New'),
                          icon: const Icon(Icons.add),
                          shortcutText: 'Ctrl+N',
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.keyN,
                            meta: true,
                          ),
                          onTap: () {
                            context.read<ResultTabBloc>().add(
                                  const NewResultTabEvent(),
                                );
                          },
                        ),
                        MenuButton(
                          text: const Text('Save'),
                          icon: const Icon(Icons.save),
                          shortcutText: 'Ctrl+S',
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.keyS,
                            meta: true,
                          ),
                          onTap: tab == null
                              ? null
                              : () {
                                  context.read<SaveResultBloc>().add(
                                        const ValidateResultEvent(),
                                      );
                                },
                        ),
                        const MenuDivider(),
                        MenuButton(
                          text: const Text('Delete'),
                          icon: const Icon(Icons.delete_forever_outlined),
                          // shortcutText: 'Ctrl+D',
                          // shortcut: const SingleActivator(
                          //   LogicalKeyboardKey.keyD,
                          //   meta: true,
                          // ),
                          onTap: tab == null
                              ? null
                              : () {
                                  context.read<ResultTabBloc>().add(
                                        const CloseResultTabEvent(),
                                      );
                                  context.read<SaveResultBloc>().add(
                                        DeleteEditedResultEvent(tab: tab),
                                      );
                                },
                        ),
                      ],
                    ),
                  ),
                  BarButton(
                    text: const Text('Upload Result'),
                    submenu: SubMenu(
                      menuItems: [
                        MenuButton(
                          text: const Text('PDF File'),
                          icon: const Icon(Icons.picture_as_pdf),
                          onTap: () {
                            final bloc = context.read<UploadResultBloc>();
                            if (bloc.state.status is ResultFileUploaded) {
                              bloc.add(const RemoveResultFileEvent());
                            }
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black12,
                              builder: (context) => const DragTargetWidget(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  BarButton(
                    text: const Text('Find Results'),
                    submenu: SubMenu(
                      menuItems: [
                        MenuButton(
                          text: const Text('By Course Code'),
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const CCSearchDialog(),
                            );
                          },
                        ),
                        MenuButton(
                          text: const Text('By Registration Number'),
                          onTap: () {
                            // showDialog(
                            //   context: context,
                            //   barrierDismissible: false,
                            //   builder: (context) => const RNSearchDialog(),
                            // );
                          },
                        ),
                      ],
                    ),
                  ),
                  BarButton(
                    text: const Text('Account'),
                    submenu: SubMenu(
                      menuItems: [
                        MenuButton(
                          text: BlocSelector<AuthBloc, AuthState, String>(
                            selector: (state) {
                              return state is AuthLoggedIn
                                  ? state.user.username
                                  : '';
                            },
                            builder: (context, name) => Text(name),
                          ),
                        ),
                        MenuButton(
                          icon: const Icon(Icons.logout),
                          text: const Text('Log Out'),
                          onTap: () {
                            context.read<AuthBloc>().add(AuthLogOut());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                child: const MySideBar(
                  width: 32,
                  expandedWidth: 112,
                  theme: MySideBarTheme(iconTheme: IconThemeData(size: 16)),
                  child: _EditResultPage(),
                ),
              );
            },
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
            child: _GridSection(),
          ),
        ),
      ],
    );
  }
}
