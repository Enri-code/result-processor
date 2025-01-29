import 'dart:async';
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
    on<UpdateResultTabDataEvent>(_onUpdateResultTabDataEvent);
    on<OpenResultTabEvent>((event, emit) {
      final tab = SavedResultTab(
        id: UniqueKey().toString(),
        resultId: event.result.id,
        title: event.result.courseCode,
      );
      _setNewTab(emit, tab);
    });
    on<GoToResultTabEvent>((event, emit) {
      emit(state.copyWith(currentTab: event.tab));
    });
    on<CloseAllResultTabsEvent>((event, emit) {
      state.editResultStates.forEach((_, value) => value.dispose());
      emit(state.copyWith(
        currentTab: const _NoResultTab(),
        resultTabs: [],
        editResultStates: {},
      ));
    });
    on<CloseResultTabEvent>((event, emit) {
      final tab = event.tab ?? state._currentTab;

      try {
        state.editResultStates[tab]?.dispose();
      } catch (e) {}
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

  FutureOr<void> _onUpdateResultTabDataEvent(
    UpdateResultTabDataEvent event,
    Emitter<ResultTabState> emit,
  ) {
    final tabIndex = state.resultTabs.indexWhere((e) => e.id == event.tab.id);
    final currentTab = state.resultTabs[tabIndex];
    emit(state.copyWith(
      resultTabs: List.from(state.resultTabs)
        ..removeAt(tabIndex)
        ..insert(tabIndex, event.tab),
      editResultStates: Map.from(state.editResultStates)
        ..remove(currentTab)
        ..[event.tab] = state.editResultStates[currentTab]!,
      currentTab: state._currentTab == currentTab ? event.tab : null,
    ));
  }

  void _setNewTab(Emitter<ResultTabState> emit, ResultTab tab) {
    emit(state.copyWith(resultTabs: [...state.resultTabs, tab]));
    add(GoToResultTabEvent(tab));
  }
}

class _NoResultTab extends ResultTab {
  const _NoResultTab() : super(id: '');
}
