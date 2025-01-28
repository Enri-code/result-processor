import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/helpers.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';
import 'package:unn_grading/src/features/results/presentation/search/open_result_bloc/open_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/search/widgets/base_search_dialog.dart';
import 'package:unn_grading/src/features/results/presentation/widgets/custom_text_fields.dart';

class OpenResultDialog extends StatefulWidget {
  const OpenResultDialog({super.key});

  @override
  State<OpenResultDialog> createState() => _OpenResultDialogState();
}

class _OpenResultDialogState extends State<OpenResultDialog> {
  final regNoController = TextEditingController();
  final departmentController = TextEditingController();
  final semesterController = TextEditingController();
  final courseCodeController = TextEditingController();
  final sessionController = TextEditingController();

  @override
  void dispose() {
    regNoController.dispose();
    sessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchDialog(
      titleWidget: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
                bodyLarge: const TextStyle(fontSize: 12, color: Colors.black),
              ),
        ),
        child: Column(
          children: [
            HeaderTitleTextField(
              controller: regNoController,
              labelText: 'Registration Number',
              hintText: 'Eg: 2019/247680',
            ),
            heightSpacing,
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: HeaderTitleTextField(
                    controller: departmentController,
                    labelText: 'Department',
                    hintText: 'Eg: Computer Science',
                  ),
                ),
                widthSpacing,
                Expanded(
                  flex: 4,
                  child: SemesterFormField(controller: semesterController),
                ),
              ],
            ),
            heightSpacing,
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: HeaderTitleTextField(
                    controller: courseCodeController,
                    labelText: 'Course Code',
                    hintText: 'Eg: COS 409',
                  ),
                ),
                widthSpacing,
                Expanded(
                  flex: 4,
                  child: HeaderTitleTextField(
                    labelText: "Session",
                    hintText: 'Eg: 2023-2024',
                    controller: sessionController,
                    style: const TextStyle(fontSize: 13),
                    validator: (val) => sessionTFValidator(val, false),
                  ),
                ),
              ],
            ),
            heightSpacing,
          ],
        ),
      ),
      searchButton: ElevatedButton(
        onPressed: _onSearch,
        child: const Text('Search'),
      ),
    );
  }

  void _onSearch() {
    context.read<OpenResultBloc>().add(SearchForResultEvent(SearchResult(
          regNo: regNoController.text,
          department: departmentController.text,
          semester: semesterController.text,
          courseCode: courseCodeController.text,
          session: sessionController.text,
        )));
  }
}
