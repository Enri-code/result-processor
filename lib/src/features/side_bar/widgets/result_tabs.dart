import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/features/result_tabs/domain/models/result_tab.dart';
import 'package:unn_grading/src/features/result_tabs/presentation/result_tab_bloc/result_tab_bloc.dart';

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
    final title = widget.tab.title ?? '(New Result)';
    // tab.title ??
    // (tab.state.courseTitleTEC.text.isEmpty
    //     ? '(No Title)'
    //     : tab.state.courseTitleTEC.text);
    return GestureDetector(
      onTap: () {
        context.read<ResultTabBloc>().add(GoToResultTabEvent(widget.tab));
      },
      child: MouseRegion(
        onHover: (event) => setState(() => isHovered = true),
        onExit: (event) => setState(() => isHovered = false),
        child: BlocSelector<ResultTabBloc, ResultTabState, bool>(
          selector: (state) => state.getCurrentTab == widget.tab,
          builder: (context, isActive) {
            return AnimatedContainer(
              height: 32,
              duration: Durations.medium1,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: isActive ? 2 : 12),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : isHovered
                        ? Colors.grey[100]
                        : Colors.grey[200],
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(isActive ? 20 : 4),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey[400]!),
                  left: BorderSide(color: Colors.grey[400]!),
                  bottom: BorderSide(color: Colors.grey[400]!),
                ),
                boxShadow: isActive || isHovered
                    ? const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                    ),
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
        ),
      ),
    );
  }
}
