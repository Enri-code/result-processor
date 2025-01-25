import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';
import 'package:unn_grading/src/features/results/presentation/search/search_result_bloc/search_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/search/widgets/base_search_dialog.dart';
import 'package:unn_grading/src/features/results/presentation/widgets/custom_text_fields.dart';

class RNSearchDialog extends StatefulWidget {
  const RNSearchDialog({super.key});

  @override
  State<RNSearchDialog> createState() => _RNSearchDialogState();
}

class _RNSearchDialogState extends State<RNSearchDialog> {
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
    return SearchDialog(
      titleWidget: Form(
        key: formKey,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Type Registration Number',
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
      searchButton: ListenableBuilder(
        listenable: searchController,
        builder: (context, child) {
          return ElevatedButton(
            onPressed: searchController.text.isEmpty ? null : _onSearch,
            child: child,
          );
        },
        child: const Text('Search'),
      ),
    );
  }

  void _onSearch() {
    if (formKey.currentState!.validate()) {
      context.read<SearchResultBloc>().add(SearchForResultEvent(
            SearchResultByRegistration(
              regNo: searchController.text,
              session: sessionController.text,
            ),
          ));
    }
  }
}
