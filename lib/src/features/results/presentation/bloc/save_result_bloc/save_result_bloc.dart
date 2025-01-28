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
      emit(ResultValidateState(
        status: event.status,
        savedResultStates: state.savedResultStates,
      ));
    });
    on<UpdateEditedResultEvent>((event, emit) async {
      final editState = event.editState;
      final results = _extractResults(editState);

      emit(ResultSaveState(
        tab: event.tab,
        status: const RequestLoading(),
        savedResultStates: state.savedResultStates,
      ));

      final res = await Future.wait([
        repo.updateResultMeta(Result(
          id: event.tab.resultId!,
          courseCode: editState.courseCodeTEC.text,
          courseTitle: editState.courseTitleTEC.text,
          semester: editState.semesterTEC.text,
          session: editState.sessionTEC.text,
          department: editState.departmentTEC.text,
          courseUnit: int.tryParse(editState.unitsTEC.text) ?? 0,
        )),
        repo.updateResultScores(event.tab.resultId!, results),
      ]);

      if (res.any((e) => e.isLeft)) {
        emit(state.copyWith(status: res.firstWhere((e) => e.isLeft).left));
      } else {
        emit(ResultSaveState(
          tab: SavedResultTab(
            id: event.tab.id,
            title: editState.courseCodeTEC.text,
            resultId: event.tab.resultId,
          ),
          status: const RequestSuccess(),
          savedResultStates: Map.from(state.savedResultStates)
            ..[event.tab] = event.editState,
        ));
      }
    });
    on<SaveEditedResultEvent>((event, emit) async {
      final editState = event.editState;

      final results = _extractResults(editState);

      emit(ResultSaveState(
        tab: event.tab,
        status: const RequestLoading(),
        savedResultStates: state.savedResultStates,
      ));

      final response = await repo.submit(ResultData(
        courseCode: editState.courseCodeTEC.text,
        courseTitle: editState.courseTitleTEC.text,
        semester: editState.semesterTEC.text,
        session: editState.sessionTEC.text,
        department: editState.departmentTEC.text,
        courseUnit: int.tryParse(editState.unitsTEC.text) ?? 0,
        scores: results,
      ));

      response.fold((left) {
        emit(state.copyWith(status: left));
      }, (right) {
        emit(ResultSaveState(
          tab: SavedResultTab(
            id: event.tab.id,
            title: editState.courseCodeTEC.text,
            resultId: right,
          ),
          status: const RequestSuccess(),
          savedResultStates: Map.from(state.savedResultStates)
            ..[event.tab] = event.editState,
        ));
      });
    });
    on<DeleteEditedResultEvent>((event, emit) async {
      emit(ResultDeleteState(
        status: const RequestLoading(),
        savedResultStates: state.savedResultStates,
        tab: event.tab,
      ));

      final response = await repo.delete(event.tab.resultId!);

      response.fold((left) {
        emit(state.copyWith(status: left));
      }, (right) {
        emit(ResultDeleteState(
          tab: event.tab,
          status: const RequestSuccess(),
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
        studentName: e.cells[ColumnKeys.studentName]!.value,
        regNo: e.cells[ColumnKeys.regNo]!.value,
        ca: int.tryParse(e.cells[ColumnKeys.test]!.value.toString()) ?? 0,
        exam: int.tryParse(e.cells[ColumnKeys.exam]!.value.toString()) ?? 0,
        total: int.tryParse(e.cells[ColumnKeys.total]!.value.toString()) ?? 0,
        grade: e.cells[ColumnKeys.grade]!.value.toString().isEmpty
            ? 'F'
            : e.cells[ColumnKeys.grade]!.value,
      );
    }).toList();

    return results;
  }
}
