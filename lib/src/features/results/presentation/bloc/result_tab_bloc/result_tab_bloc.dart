import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/features/results/domain/models/result.dart';
import 'package:unn_grading/src/features/results/presentation/bloc/edit_result_bloc/edit_result_bloc.dart';
import 'package:unn_grading/src/features/results/domain/models/result_tab.dart';

part 'result_tab_event.dart';
part 'result_tab_state.dart';

class ResultTabBloc extends Bloc<ResultTabEvent, ResultTabState> {
  ResultTabBloc() : super(const ResultTabState()) {
    on<NewResultTabEvent>((event, emit) {
      final tab = NewResultTab(id: UniqueKey().toString());
      _setNewTab(emit, tab);
    });
    on<OpenResultTabEvent>((event, emit) {
      final tab = NewResultTab(
        title: event.result.courseCode,
        id: event.result.id ?? UniqueKey().toString(),
      );
      _setNewTab(emit, tab);
    });
    on<GoToResultTabEvent>((event, emit) {
      emit(state.copyWith(currentTab: event.tab));
    });
    on<CloseAllResultTabsEvent>((event, emit) {
      emit(state.copyWith(
        currentTab: const _NoResultTab(),
        resultTabs: [],
        editResultStates: {},
      ));
    });
    on<CloseResultTabEvent>((event, emit) {
      final tab = event.tab ?? state._currentTab;

      state.editResultStates[tab]?.dispose();
      emit(state.copyWith(
        resultTabs: List.from(state.resultTabs)..remove(tab),
        editResultStates: Map.from(state.editResultStates)..remove(tab),
      ));

      if (state._currentTab == tab) {
        emit(state.copyWith(currentTab: const _NoResultTab()));
      }

      add(GoToResultTabEvent(state.getCurrentTab ?? const _NoResultTab()));
    });
    on<CacheEditResultStateEvent>((event, emit) {
      if (state._currentTab != null) {
        emit(state.copyWith(
          editResultStates: Map.from(state.editResultStates)
            ..[state._currentTab!] = event.state,
        ));
      }
    });
  }

  void _setNewTab(Emitter<ResultTabState> emit, ResultTab tab) {
    emit(state.copyWith(resultTabs: [...state.resultTabs, tab]));
    add(GoToResultTabEvent(tab));
  }
}

class _NoResultTab extends ResultTab {
  const _NoResultTab() : super(id: '');
}
