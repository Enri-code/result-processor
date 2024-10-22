import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/features/edit_result/presentation/edit_result_bloc/edit_result_bloc.dart';
import 'package:unn_grading/src/features/result_tabs/domain/models/result_tab.dart';

part 'result_tab_event.dart';
part 'result_tab_state.dart';

class ResultTabBloc extends Bloc<ResultTabEvent, ResultTabState> {
  ResultTabBloc() : super(const ResultTabState()) {
    on<NewResultTabEvent>((event, emit) {
      final tab = NewResultTab(id: UniqueKey().toString());
      _setNewTab(emit, tab);
    });
    // on<OpenResultTabEvent>((event, emit) {
    //   final key = UniqueKey().toString();
    //   final tab = OpenResultTab(
    //     title: key,
    //     id: key,
    //     source: ResultTabSourceLocal(''),
    //   );

    //   _setNewTab(emit, tab);
    // });
    on<GoToResultTabEvent>((event, emit) {
      emit(state.copyWith(currentTab: event.tab));
    });
    on<SaveEditResultSetStateEvent>((event, emit) {
      emit(state.copyWith(
        editResultStates: Map.from(state.editResultStates)
          ..[state.getCurrentTab!] = event.state,
      ));
    });
    on<CloseResultTabEvent>((event, emit) {
      emit(state.copyWith(
        resultTabs: List.from(state.resultTabs)..remove(event.tab),
      ));

      if (state._currentTab == event.tab) {
        if (state.resultTabs.isEmpty) {
          emit(state.copyWith(currentTab: const _NoResultTab()));
        } else {
          emit(state.copyWith(currentTab: state.resultTabs.firstOrNull));
        }
      }

      if (state.getCurrentTab != null) {
        add(GoToResultTabEvent(state.getCurrentTab!));
      }

      state.editResultStates[event.tab]?.dispose();
      emit(state.copyWith(
        editResultStates: Map.from(state.editResultStates)..remove(event.tab),
      ));
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
