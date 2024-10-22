import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'side_bar_event.dart';
part 'side_bar_state.dart';

class SideBarBloc extends Bloc<SideBarEvent, SideBarState> {
  SideBarBloc() : super(const SideBarState()) {
    on<ExpandSideBarEvent>((event, emit) {
      emit(state.copyWith(expanded: event.isExpanded));
    });
    on<SetSideBarShrinkMode>((event, emit) {
      emit(state.copyWith(canShrink: event.canShrink));
    });
    // on<SetSideBarOverflowMode>((event, emit) {
    //   emit(state.copyWith(canOverflow: event.canOverflow));
    // });
  }
}
