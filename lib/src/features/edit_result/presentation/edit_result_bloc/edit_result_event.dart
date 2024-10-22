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

class ExportResultEvent extends EditResultEvent {
  const ExportResultEvent(this.exporter);
  final ExportPlutoGridResult exporter;
}

abstract class ModifyGridEvent extends EditResultEvent {
  const ModifyGridEvent();

  void onModify(EditResultState state, PlutoGridStateManager stateManager);
}

class RemoveRowsEvent extends ModifyGridEvent {
  final List<int> indexes;

  const RemoveRowsEvent({required this.indexes});

  @override
  void onModify(EditResultState state, PlutoGridStateManager stateManager) {
    stateManager.removeRows(
      (state.modifyGridEvent as RemoveRowsEvent).indexes.map((i) {
        return stateManager.refRows[i];
      }).toList(),
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
    final event = state.modifyGridEvent as InsertRowsEvent;
    final index = event.index ?? stateManager.refRows.length;

    final rowsToBeAdded =
        event.rows ?? state.rows.getRange(index, index + event.count).toList();

    stateManager.insertRows(index, rowsToBeAdded);
    // PlutoGridStateManager.initializeRowsAsync(
    //   gridColumns,
    //   rowsToBeAdded,
    //   chunkSize: 20,
    //   start: index,
    // ).then((value) {
    //   print('$index -> ${value.length}');
    //   stateManager.refRows.insertAll(index, value);
    //   // stateManager.notifyListeners();
    // });
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