import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/search/search_result_bloc/search_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/search/widgets/result_item.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({
    super.key,
    required this.titleWidget,
    required this.searchButton,
  });

  final Widget titleWidget, searchButton;

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchResultBloc, SearchResultState>(
      listener: (context, state) {
        if (state is SearchResultOpenedState) Navigator.of(context).pop();
      },
      child: Dialog(
        insetPadding: const EdgeInsets.all(40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                widget.titleWidget,
                const Divider(height: 0),
                Expanded(
                  child: BlocBuilder<SearchResultBloc, SearchResultState>(
                    builder: (context, state) {
                      return ListView.builder(
                        itemCount: state.results.length,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (context, i) {
                          // final result = Result(
                          //   id: '',
                          //   courseCode: 'COS 444',
                          //   courseTitle: 'Final Year Project',
                          //   semester: 'First',
                          //   session: '2020-2021',
                          //   department: 'Computer Science',
                          //   courseUnit: 4,
                          // );
                          return ResultItemWidget(
                            result: state.results[i],
                            onTap: () {
                              context.read<SearchResultBloc>().add(
                                    OpenSearchResultEvent(state.results[i]),
                                  );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const Divider(height: 0),
                const SizedBox(height: 10),
                Row(
                  children: [
                    BlocBuilder<SearchResultBloc, SearchResultState>(
                      builder: (context, state) {
                        if (state is SearchResultLoadingState) {
                          return const Row(
                            children: [
                              SizedBox.square(
                                dimension: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Loading...'),
                            ],
                          );
                        } else if (state is SearchResultOpeningState) {
                          return const Row(
                            children: [
                              SizedBox.square(
                                dimension: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Opening...'),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      style: const ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.red),
                      ),
                      child: const Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    widget.searchButton,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
