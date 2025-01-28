import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/domain/models/result.dart';
import 'package:unn_grading/src/features/results/presentation/pages/pluto_grid_grading_page.dart';

part 'edit_result_event.dart';
part 'edit_result_state.dart';

class EditResultBloc extends Bloc<EditResultEvent, EditResultState> {
  EditResultBloc() : super(EditResultState()) {
    on<RemoveRowsEvent>((event, emit) {
      final newRows = List<PlutoRow>.from(state.rows);
      event.indexes.forEach(newRows.removeAt);

      emit(state.copyWith(rows: newRows, event: event));
    });
    on<InsertRowsEvent>((event, emit) {
      final rowsToBeAdded = event.rows ??
          List.generate(event.count, (_) {
            // generate empty row cells
            return PlutoRow(cells: {
              ColumnKeys.studentName: PlutoCell(value: ''),
              ColumnKeys.regNo: PlutoCell(value: ''),
              ColumnKeys.test: PlutoCell(value: ''),
              ColumnKeys.exam: PlutoCell(value: ''),
              ColumnKeys.total: PlutoCell(value: ''),
              ColumnKeys.grade: PlutoCell(value: ''),
            });
          });

      // insert rows to index (default to end of list)
      emit(state.copyWith(
        event: event,
        rows: List.from(state.rows)
          ..insertAll(event.index ?? state.rows.length, rowsToBeAdded),
      ));
    });
    on<CalculateRowData>((event, emit) {
      int? total;
      try {
        total = _calculateRowTotal(event.row.cells).toInt();
        // ignore: empty_catches
      } catch (e) {}
      event.row.cells[ColumnKeys.total]!.value = total ?? '';
      event.row.cells[ColumnKeys.grade]!.value =
          total == null ? '' : _calculateGrade(total);

      emit(state.copyWith(event: event));
    });
    on<UpdateCellData>((event, emit) {
      state.rows[event.rowId].cells[event.columnField]?.value = event.value;
    });
    on<SetEditResultStateEvent>((event, emit) {
      emit(event.state ?? EditResultState());
    });
    on<OpenResultDataEvent>((event, emit) {
      final rows = event.data.scores.map((e) {
        return PlutoRow(cells: {
          ColumnKeys.studentName: PlutoCell(value: e.studentName),
          ColumnKeys.regNo: PlutoCell(value: e.regNo),
          ColumnKeys.test: PlutoCell(value: e.ca),
          ColumnKeys.exam: PlutoCell(value: e.exam),
          ColumnKeys.total: PlutoCell(value: e.total),
          ColumnKeys.grade: PlutoCell(value: e.grade),
        });
      }).toList();

      final state = EditResultState(
        rows: rows,
        modifyGridEvent: event._copyWith(rows: rows),
        courseCodeTEC: TextEditingController(text: event.data.courseCode),
        courseTitleTEC: TextEditingController(text: event.data.courseTitle),
        semesterTEC: TextEditingController(text: event.data.semester),
        sessionTEC: TextEditingController(text: event.data.session),
        departmentTEC: TextEditingController(text: event.data.department),
        unitsTEC: TextEditingController(
          text: event.data.courseUnit?.toString(),
        ),
      );

      emit(state);
    });
  }
}

num _calculateRowTotal(Map<String, PlutoCell> cells) {
  num getScoreFromCell(String cellKey) {
    final value = cells[cellKey]!.value.toString();
    return num.parse(value);
  }

  return getScoreFromCell(ColumnKeys.test) + getScoreFromCell(ColumnKeys.exam);
}

String _calculateGrade(num score) {
  if (score >= 70) return 'A';
  if (score >= 60) return 'B';
  if (score >= 50) return 'C';
  if (score >= 40) return 'D';
  if (score >= 30) return 'E';
  return 'F';
}
