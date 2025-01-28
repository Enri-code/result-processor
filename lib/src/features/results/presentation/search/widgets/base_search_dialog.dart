import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/helpers.dart';
import 'package:unn_grading/src/features/results/presentation/search/open_result_bloc/open_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/search/widgets/result_item.dart';

class SearchDialog extends StatelessWidget {
  const SearchDialog({
    super.key,
    required this.titleWidget,
    required this.searchButton,
  });

  final Widget titleWidget, searchButton;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OpenResultBloc, OpenResultState>(
      listener: (context, state) {
        if (state is ResultOpenedState) Navigator.of(context).pop();
      },
      child: Dialog(
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: BlocListener<OpenResultBloc, OpenResultState>(
          listener: (context, state) {
            if (state is SearchResultErrorState) {
              showSnackBar(context, state.error.message);
            }
          },
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Column(
                children: [
                  titleWidget,
                  const Divider(height: 0),
                  Expanded(
                    child: BlocBuilder<OpenResultBloc, OpenResultState>(
                      builder: (context, state) {
                        return ListView.builder(
                          itemCount: state.results.length,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (context, i) {
                            return ResultItemWidget(
                              result: state.results[i],
                              onTap: () {
                                context.read<OpenResultBloc>().add(
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
                  heightSpacing,
                  Row(
                    children: [
                      BlocBuilder<OpenResultBloc, OpenResultState>(
                        builder: (context, state) {
                          if (state is SearchResultLoadingState) {
                            return const Row(
                              children: [
                                SizedBox.square(
                                  dimension: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text('Loading...'),
                              ],
                            );
                          } else if (state is ResultOpeningState) {
                            return const Row(
                              children: [
                                SizedBox.square(
                                  dimension: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 6),
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
                      searchButton,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
