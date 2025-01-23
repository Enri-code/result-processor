part of 'save_result_bloc.dart';

sealed class SaveResultEvent extends Equatable {
  const SaveResultEvent();

  @override
  List<Object> get props => [];
}

class ValidateResultEvent extends SaveResultEvent {
  const ValidateResultEvent();
}

class SaveEditedResultEvent extends SaveResultEvent {
  const SaveEditedResultEvent({required this.editState, required this.tab});
  final EditResultState editState;
  final ResultTab tab;
}

class DeleteEditedResultEvent extends SaveResultEvent {
  const DeleteEditedResultEvent({required this.tab});
  final ResultTab tab;
}

class UpdateEditedResultEvent extends SaveResultEvent {
  const UpdateEditedResultEvent({required this.editState, required this.tab});
  final EditResultState editState;
  final ResultTab tab;
}
