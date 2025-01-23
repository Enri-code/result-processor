part of 'result_tab_bloc.dart';

class ResultTabState extends Equatable {
  const ResultTabState({
    this.resultTabs = const [],
    this.editResultStates = const {},
    ResultTab? currentTab,
  }) : _currentTab = currentTab;

  final List<ResultTab> resultTabs;
  final Map<ResultTab, EditResultState> editResultStates;

  final ResultTab? _currentTab;
  ResultTab? get getCurrentTab => _currentTab ?? resultTabs.firstOrNull;

  ResultTabState copyWith({
    List<ResultTab>? resultTabs,
    Map<ResultTab, EditResultState>? editResultStates,
    ResultTab? currentTab,
  }) {
    return ResultTabState(
      resultTabs: resultTabs ?? this.resultTabs,
      editResultStates: editResultStates ?? this.editResultStates,
      currentTab: currentTab is _NoResultTab ? null : currentTab ?? _currentTab,
    );
  }

  @override
  List<Object?> get props => [resultTabs, editResultStates, _currentTab];
}
