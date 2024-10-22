part of 'result_tab_bloc.dart';

sealed class ResultTabEvent extends Equatable {
  const ResultTabEvent();

  @override
  List<Object> get props => [];
}

class NewResultTabEvent extends ResultTabEvent {
  const NewResultTabEvent();
}

// class OpenResultTabEvent extends ResultTabEvent {
//   const OpenResultTabEvent();
// }

class SaveEditResultSetStateEvent extends ResultTabEvent {
  const SaveEditResultSetStateEvent({required this.state});
  final EditResultState state;
}

// class CloseResultTab extends ResultTabEvent {
//   const CloseResultTab();
// }

class GoToResultTabEvent extends ResultTabEvent {
  const GoToResultTabEvent(this.tab);
  final ResultTab tab;
}

class CloseResultTabEvent extends ResultTabEvent {
  const CloseResultTabEvent(this.tab);
  final ResultTab tab;
}
