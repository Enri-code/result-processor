import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/features/results/domain/models/result.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';
import 'package:unn_grading/src/features/results/presentation/search/search_result_bloc/search_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/search/widgets/result_item.dart';
import 'package:unn_grading/src/features/results/presentation/widgets/custom_text_fields.dart';

class CCSearchDialog extends StatefulWidget {
  const CCSearchDialog({super.key});

  @override
  State<CCSearchDialog> createState() => _CCSearchDialogState();
}

class _CCSearchDialogState extends State<CCSearchDialog> {
  final searchController = TextEditingController();
  final sessionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    searchController.dispose();
    sessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
              Form(
                key: formKey,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Type Course Code',
                          prefixIcon: Icon(Icons.search_rounded),
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) => _onSearch(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: HeaderTitleTextField(
                        labelText: "Session",
                        hintText: 'Eg: 2023-2024',
                        controller: sessionController,
                        style: const TextStyle(fontSize: 13),
                        validator: (value) {
                          if (value!.isEmpty) return null;
                          if (!RegExp(r"^\d{4}-\d{4}$").hasMatch(value)) {
                            return '';
                          } else if (value.split('-').fold(0, (p, e) {
                                return int.parse(e) - p;
                              }) !=
                              1) {
                            return '';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: ListView.builder(
                  itemCount: 16,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemBuilder: (context, index) {
                    return ResultItemWidget(
                      result: Result(
                        courseCode: 'COS 444',
                        courseTitle: 'Final Year Project',
                        semester: 'First',
                        session: '2020-2021',
                        department: 'Computer Science',
                        courseUnit: 4,
                      ),
                      onTap: () {},
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
                      if (state is! SearchResultLoadingState) {
                        return const SizedBox();
                      }
                      return const Row(
                        children: [
                          SizedBox.square(
                            dimension: 15,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Loading...'),
                        ],
                      );
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
                  ListenableBuilder(
                    listenable: searchController,
                    builder: (context, child) {
                      return ElevatedButton(
                        onPressed:
                            searchController.text.isEmpty ? null : _onSearch,
                        child: child,
                      );
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearch() {
    if (formKey.currentState!.validate()) {
      context.read<SearchResultBloc>().add(SearchCourseCodeResultEvent(
            SearchResultByCourse(
              courseCode: searchController.text,
              session: sessionController.text,
            ),
          ));
    }
  }
}
