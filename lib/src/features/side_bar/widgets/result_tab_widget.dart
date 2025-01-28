import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/constants/app_color.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/domain/models/result_tab.dart';
import 'package:unn_grading/src/features/results/presentation/bloc/result_tab_bloc/result_tab_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/bloc/save_result_bloc/save_result_bloc.dart';

class ResultTabWiget extends StatefulWidget {
  const ResultTabWiget({super.key, required this.tab});
  final ResultTab tab;

  @override
  State<ResultTabWiget> createState() => _ResultTabWigetState();
}

class _ResultTabWigetState extends State<ResultTabWiget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final title = (widget.tab.title?.isEmpty ?? true)
        ? '[New Result]'
        : widget.tab.title!;
    return GestureDetector(
      onTap: () {
        context.read<ResultTabBloc>().add(GoToResultTabEvent(widget.tab));
      },
      child: MouseRegion(
        onHover: (event) => setState(() => isHovered = true),
        onExit: (event) => setState(() => isHovered = false),
        child: BlocBuilder<SaveResultBloc, SaveResultState>(
          builder: (context, state) {
            bool isDeleting = state is ResultDeleteState &&
                state.status is RequestLoading &&
                state.tab == widget.tab;
            bool isSaving = state is ResultSaveState &&
                state.status is RequestLoading &&
                state.tab == widget.tab;
            return BlocSelector<ResultTabBloc, ResultTabState, bool>(
              selector: (state) => state.getCurrentTab == widget.tab,
              builder: (context, isActive) {
                return AnimatedContainer(
                  height: 32,
                  duration: Durations.medium1,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: isActive ? 2 : 12, right: 4),
                  padding: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white
                        : isHovered
                            ? Colors.grey[100]
                            : Colors.grey[200],
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(isActive ? 20 : 4),
                    ),
                    border: Border.all(
                      color: isDeleting ? Colors.red[400]! : Colors.grey[400]!,
                    ),
                    boxShadow: isActive || isHovered
                        ? const [
                            BoxShadow(
                              blurRadius: 2,
                              color: Colors.black12,
                              offset: Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 3),
                      Expanded(
                        child: isDeleting
                            ? Text(
                                'Deleting $title',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.red),
                              )
                            : isSaving
                                ? Text(
                                    widget.tab is SavedResultTab
                                        ? 'Updating $title'
                                        : 'Saving $title',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColor.primary,
                                    ),
                                  )
                                : Text(title, overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 4),
                      if (isHovered)
                        GestureDetector(
                          onTap: () {
                            context.read<ResultTabBloc>().add(
                                  CloseResultTabEvent(widget.tab),
                                );
                          },
                          child: const Icon(Icons.close),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
