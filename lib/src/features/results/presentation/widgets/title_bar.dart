import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_bar/menu_bar.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:unn_grading/src/features/results/domain/models/result_tab.dart';
import 'package:unn_grading/src/features/results/presentation/bloc/result_tab_bloc/result_tab_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/bloc/save_result_bloc/save_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/search/open_result_bloc/open_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/search/widgets/open_result_dialog.dart';
import 'package:unn_grading/src/features/results/presentation/upload/upload_result_bloc/upload_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/upload/widgets/upload_file.dart';
import 'package:unn_grading/src/features/security/presentation/security_bloc/security_bloc.dart';
import 'package:unn_grading/src/features/security/presentation/widgets/action_logs_dialog.dart';

class TitleBarWidget extends StatelessWidget {
  const TitleBarWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return BlocSelector<ResultTabBloc, ResultTabState, ResultTab?>(
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
                        text: const Text('Open'),
                        icon: const Icon(Icons.file_open),
                        shortcutText: 'Ctrl+O',
                        shortcut: const SingleActivator(
                          LogicalKeyboardKey.keyO,
                          meta: true,
                        ),
                        onTap: () {
                          context.read<OpenResultBloc>().add(
                                const GetSavedResultsEvent(),
                              );
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return const OpenResultDialog();
                            },
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
                                      const ValidateResultEvent(
                                          RequestLoading()),
                                    );
                              },
                      ),
                      const MenuDivider(),
                      MenuButton(
                        text: const Text('Delete'),
                        icon: const Icon(Icons.delete_forever_outlined),
                        shortcutText: 'Ctrl+D',
                        shortcut: const SingleActivator(
                          LogicalKeyboardKey.keyD,
                          meta: true,
                        ),
                        onTap: tab == null || tab is! SavedResultTab
                            ? null
                            : () {
                                context.read<SaveResultBloc>().add(
                                      DeleteEditedResultEvent(tab: tab),
                                    );
                              },
                      ),
                      const MenuDivider(),
                      MenuButton(
                        text: const Text('Close'),
                        icon: const Icon(Icons.close),
                        shortcutText: 'Ctrl+X',
                        shortcut: const SingleActivator(
                          LogicalKeyboardKey.keyC,
                          meta: true,
                        ),
                        onTap: tab == null
                            ? null
                            : () {
                                context.read<ResultTabBloc>().add(
                                      CloseResultTabEvent(tab),
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
                          context.read<UploadResultBloc>().add(
                                const SetResultFileTypeEvent(
                                    ResultFileType.pdf),
                              );
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const DragTargetWidget(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // BarButton(
                //   text: const Text('Search'),
                //   submenu: SubMenu(
                //     menuItems: [
                //       MenuButton(
                //         text: const Text('By Course Code'),
                //         onTap: () {
                //           showDialog(
                //             context: context,
                //             barrierDismissible: false,
                //             builder: (context) => const CCSearchDialog(),
                //           );
                //         },
                //       ),
                //       MenuButton(
                //         text: const Text('By Semester'),
                //         onTap: () {
                //           showDialog(
                //             context: context,
                //             barrierDismissible: false,
                //             builder: (context) => const SMSearchDialog(),
                //           );
                //         },
                //       ),
                //       // MenuButton(
                //       //   text: const Text('By Student Name'),
                //       //   onTap: () {
                //       //     showDialog(
                //       //       context: context,
                //       //       barrierDismissible: false,
                //       //       builder: (context) => const SNSearchDialog(),
                //       //     );
                //       //   },
                //       // ),
                //       MenuButton(
                //         text: const Text('By Registration Number'),
                //         onTap: () {
                //           showDialog(
                //             context: context,
                //             barrierDismissible: false,
                //             builder: (context) => const RNSearchDialog(),
                //           );
                //         },
                //       ),
                //     ],
                //   ),
                // ),
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
                        text: BlocSelector<AuthBloc, AuthState, String>(
                          selector: (state) {
                            return state is AuthLoggedIn
                                ? state.user.email
                                : '';
                          },
                          builder: (context, name) => Text(name),
                        ),
                      ),
                      const MenuDivider(),
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
                // if (state is AuthLoggedIn &&
                //     [Role.admin, Role.hod].contains(state.user.role))
                BarButton(
                  text: const Text('Admin'),
                  submenu: SubMenu(
                    menuItems: [
                      MenuButton(
                        icon: const Icon(Icons.data_array),
                        text: const Text('View Logs'),
                        onTap: () {
                          context.read<SecurityBloc>().add(
                                const GetActivityLogsEvent(),
                              );
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const ActionLogsDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
              child: child,
            );
          },
        );
      },
    );
  }
}
