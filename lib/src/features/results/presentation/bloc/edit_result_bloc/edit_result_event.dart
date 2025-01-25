part of 'edit_result_bloc.dart';

sealed class EditResultEvent extends Equatable {
  const EditResultEvent();

  @override
  List<Object> get props => [];
}

class UpdateCellData extends EditResultEvent {
  final int rowId;
  final String columnField;
  final dynamic value;
  const UpdateCellData(this.rowId, this.columnField, this.value);
}

class SetEditResultStateEvent extends EditResultEvent {
  const SetEditResultStateEvent({this.state});
  final EditResultState? state;
}

class SetOpenResultStateEvent extends ModifyGridEvent {
  const SetOpenResultStateEvent(this.data) : _rows = const [];

  const SetOpenResultStateEvent._(this.data, {List<PlutoRow>? rows})
      : _rows = rows ?? const [];

  final ResultData data;
  final List<PlutoRow> _rows;

  @override
  void onModify(EditResultState state, PlutoGridStateManager stateManager) {
    stateManager.insertRows(0, _rows);
  }

  SetOpenResultStateEvent _copyWith({ResultData? data, List<PlutoRow>? rows}) {
    return SetOpenResultStateEvent._(data ?? this.data, rows: rows ?? _rows);
  }
}

// class ExportResultEvent extends EditResultEvent {
//   // const ExportResultEvent(this.exporter);
//   // final ExportPlutoGridResult exporter;
// }

abstract class ModifyGridEvent extends EditResultEvent {
  const ModifyGridEvent();

  /// Each [ModifyGridEvent] has a function to be called to update the
  /// UI's state with the new values sent to the Bloc.
  /// A BlocListener in the Widget tree shall listen for these events's data
  /// and handle appropraitely
  void onModify(EditResultState state, PlutoGridStateManager stateManager);
}

class RemoveRowsEvent extends ModifyGridEvent {
  final List<int> indexes;
  const RemoveRowsEvent({required this.indexes});

  @override
  void onModify(EditResultState state, PlutoGridStateManager stateManager) {
    stateManager.removeRows(
      indexes.map((i) => stateManager.refRows[i]).toList(),
    );
  }
}

class InsertRowsEvent extends ModifyGridEvent {
  final List<PlutoRow>? rows;
  final int? index;
  final int count;

  const InsertRowsEvent({this.rows, this.index, this.count = 1});

  @override
  void onModify(EditResultState state, PlutoGridStateManager stateManager) {
    final i = index ?? stateManager.refRows.length;
    final rowsToBeAdded = rows ?? state.rows.getRange(i, i + count).toList();

    stateManager.insertRows(i, rowsToBeAdded);
  }
}

class CalculateRowData extends ModifyGridEvent {
  final PlutoRow row;
  const CalculateRowData(this.row);

  @override
  void onModify(EditResultState state, PlutoGridStateManager stateManager) {
    stateManager.notifyListeners();
  }
}
