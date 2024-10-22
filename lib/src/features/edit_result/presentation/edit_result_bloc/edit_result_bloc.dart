import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:unn_grading/src/features/edit_result/domain/export.dart';
import 'package:unn_grading/src/features/edit_result/presentation/pages/pluto_grid_grading_page.dart';

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
              ColumnKeys.fullname: PlutoCell(value: ''),
              ColumnKeys.studentId: PlutoCell(value: ''),
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
    on<ExportResultEvent>((event, emit) => event.exporter.export());
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
