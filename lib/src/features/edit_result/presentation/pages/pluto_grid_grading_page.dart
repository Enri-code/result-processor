import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:unn_grading/src/core/constants/app_color.dart';
import 'package:unn_grading/src/core/utils/helpers.dart';
import 'package:unn_grading/src/features/edit_result/presentation/edit_result_bloc/edit_result_bloc.dart';
import 'package:unn_grading/src/features/result_tabs/domain/models/result_tab.dart';
import 'package:unn_grading/src/features/result_tabs/presentation/result_tab_bloc/result_tab_bloc.dart';
import 'package:unn_grading/src/features/side_bar/widgets/side_bar.dart';

part '../widgets/grading_section.dart';
part '../widgets/header_section.dart';

class PlutoGridGradingPage extends StatelessWidget {
  const PlutoGridGradingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ResultTabBloc()),
        BlocProvider(create: (_) => EditResultBloc()),
      ],
      child: MultiBlocListener(
        listeners: [
          // When the Tab changes, update the [EditResultBloc]'s state to
          // corresponding Tab State
          BlocListener<ResultTabBloc, ResultTabState>(
            listenWhen: (p, c) => p.getCurrentTab != c.getCurrentTab,
            listener: (context, state) {
              if (state.getCurrentTab == null) return;
              final editState = state.editResultStates[state.getCurrentTab!];
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
              context.read<ResultTabBloc>().add(SaveEditResultSetStateEvent(
                    state: context.read<EditResultBloc>().state,
                  ));
            },
          ),
        ],
        child: Scaffold(
          body: BlocSelector<ResultTabBloc, ResultTabState, ResultTab?>(
            selector: (state) => state.getCurrentTab,
            builder: (context, getCurrentTab) {
              return MySideBar(
                width: 32,
                expandedWidth: 112,
                theme: const MySideBarTheme(iconTheme: IconThemeData(size: 16)),
                items: [
                  MySideBarItem(
                    icon: Icons.add,
                    label: 'New',
                    onPointerUp: (_) {
                      context
                          .read<ResultTabBloc>()
                          .add(const NewResultTabEvent());
                    },
                  ),
                  MySideBarItem(
                    icon: Icons.file_open_outlined,
                    label: 'Open',
                    onPointerUp: (_) {},
                  ),
                  MySideBarItem(
                    enabled: getCurrentTab != null,
                    icon: Icons.save,
                    label: 'Save',
                    onPointerUp: (_) {},
                  ),
                  MySideBarItem(
                    enabled: getCurrentTab != null,
                    icon: Icons.delete_outline,
                    label: 'Delete',
                    onPointerUp: (_) {},
                  ),
                  MySideBarItem(
                    icon: Icons.call_received,
                    label: 'Import table',
                    onPointerUp: (_) {},
                  ),
                  MySideBarItem(
                    enabled: getCurrentTab != null,
                    icon: Icons.output_outlined,
                    label: 'Export table',
                    onPointerUp: (event) {
                      showCustomMenu(
                        context,
                        position: event.position,
                        items: [
                          PopupMenuItem(
                            height: 36,
                            child: const Text(
                              'Export to PDF',
                              style: TextStyle(fontSize: 13),
                            ),
                            onTap: () {
                              // context.read<EditResultBloc>().add(
                              //       ExportResultEvent(
                              //         ExportPDFResult(stateManager),
                              //       ),
                              //     );
                            },
                          ),
                          PopupMenuItem(
                            height: 36,
                            child: const Text(
                              'Export to CSV',
                              style: TextStyle(fontSize: 13),
                            ),
                            onTap: () {
                              // context.read<EditResultBloc>().add(
                              //       const ExportResultEvent(ExportOption.csv),
                              //     );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
                child: const _EditResultPage(),
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
      margin: const EdgeInsets.fromLTRB(0, 12, 12, 2),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(blurRadius: 4, offset: Offset(0, -1), color: Colors.black26)
        ],
      ),
      child: BlocSelector<ResultTabBloc, ResultTabState, ResultTab?>(
        selector: (state) => state.getCurrentTab,
        builder: (context, getCurrentTab) {
          if (getCurrentTab != null) {
            return _ResultTabSection(tab: getCurrentTab);
          }
          return Center(
            child: TextButton(
              onPressed: () {
                context.read<ResultTabBloc>().add(const NewResultTabEvent());
              },
              child: const Text('+ New', style: TextStyle(fontSize: 32)),
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
        SizedBox(height: 20),
        _HeaderSection(),
        SizedBox(height: 20),
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
