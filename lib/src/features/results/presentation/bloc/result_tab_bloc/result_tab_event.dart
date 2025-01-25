part of 'result_tab_bloc.dart';

sealed class ResultTabEvent extends Equatable {
  const ResultTabEvent();

  @override
  List<Object> get props => [];
}

class NewResultTabEvent extends ResultTabEvent {
  const NewResultTabEvent();
}

class OpenResultTabEvent extends ResultTabEvent {
  const OpenResultTabEvent(this.result);
  final Result result;
}

class CacheEditResultStateEvent extends ResultTabEvent {
  const CacheEditResultStateEvent({required this.state});
  final EditResultState state;
}

class GoToResultTabEvent extends ResultTabEvent {
  const GoToResultTabEvent(this.tab);
  final ResultTab tab;
}

class CloseResultTabEvent extends ResultTabEvent {
  const CloseResultTabEvent([this.tab]);
  final ResultTab? tab;
}

class CloseAllResultTabsEvent extends ResultTabEvent {
  const CloseAllResultTabsEvent();
}
