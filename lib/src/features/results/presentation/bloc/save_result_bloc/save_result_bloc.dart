import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/domain/models/result.dart';
import 'package:unn_grading/src/features/results/domain/models/result_tab.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';
import 'package:unn_grading/src/features/results/presentation/bloc/edit_result_bloc/edit_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/pages/pluto_grid_grading_page.dart';

part 'save_result_event.dart';
part 'save_result_state.dart';

class SaveResultBloc extends Bloc<SaveResultEvent, SaveResultState> {
  final ResultRepository repo;
  SaveResultBloc(this.repo) : super(const SaveResultInitial()) {
    on<ValidateResultEvent>((event, emit) {
      emit(ValidateResultState(
        status: const RequestSuccess(),
        savedResultStates: state.savedResultStates,
      ));
    });
    on<UpdateEditedResultEvent>((event, emit) async {
      final editState = event.editState;

      final results = _extractResults(editState);
      final oldResults = _extractResults(state.savedResultStates[event.tab]!);

      results != oldResults;

      final response = await repo.update(UpdateResultData(
        courseCode: editState.courseCodeTEC.text,
        // courseTitle: editState.courseTitleTEC.text,
        semester: editState.semesterTEC.text,
        session: editState.sessionTEC.text,
        regNo: '',
        // department: editState.departmentTEC.text,
        // courseUnit: int.tryParse(editState.unitsTEC.text),
        // results: results,
      ));

      response.fold((left) {
        emit(state.copyWith(status: left));
      }, (right) {
        emit(ResultSavedState(
          savedResultStates: Map.from(state.savedResultStates)
            ..[event.tab] = event.editState,
        ));
      });
    });
    on<SaveEditedResultEvent>((event, emit) async {
      final editState = event.editState;

      final results = _extractResults(editState);

      final response = await repo.submit(ResultData(
        courseCode: editState.courseCodeTEC.text,
        courseTitle: editState.courseTitleTEC.text,
        semester: editState.semesterTEC.text,
        session: editState.sessionTEC.text,
        department: editState.departmentTEC.text,
        courseUnit: int.tryParse(editState.unitsTEC.text),
        results: results,
      ));

      response.fold((left) {
        emit(state.copyWith(status: left));
      }, (right) {
        emit(ResultSavedState(
          savedResultStates: Map.from(state.savedResultStates)
            ..[event.tab] = event.editState,
        ));
      });
    });
    on<DeleteEditedResultEvent>((event, emit) async {
      final response = await repo.delete(event.tab.id);

      response.fold((left) {
        emit(state.copyWith(status: left));
      }, (right) {
        emit(ResultSavedState(
          savedResultStates: Map.from(state.savedResultStates)
            ..remove(event.tab),
        ));
      });
    });
  }

  List<Score> _extractResults(EditResultState editState) {
    final results = editState.rows.where((e) {
      return e.cells.values.any((e) => e.value.toString().isNotEmpty);
    }).map((e) {
      return Score(
        fullname: e.cells[ColumnKeys.fullname]!.value,
        regNo: e.cells[ColumnKeys.studentId]!.value,
        grade: e.cells[ColumnKeys.grade]!.value,
        ca: int.tryParse(e.cells[ColumnKeys.test]!.value) ?? 0,
        exam: int.tryParse(e.cells[ColumnKeys.exam]!.value) ?? 0,
        total: int.tryParse(e.cells[ColumnKeys.total]!.value) ?? 0,
      );
    }).toList();

    return results;
  }
}
