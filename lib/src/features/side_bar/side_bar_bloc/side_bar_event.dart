part of 'side_bar_bloc.dart';

sealed class SideBarEvent extends Equatable {
  const SideBarEvent();

  @override
  List<Object> get props => [];
}

class ExpandSideBarEvent extends SideBarEvent {
  final bool isExpanded;
  const ExpandSideBarEvent(this.isExpanded);
}

class SetSideBarShrinkMode extends SideBarEvent {
  final bool canShrink;
  const SetSideBarShrinkMode(this.canShrink);
}

// class SetSideBarOverflowMode extends SideBarEvent {
//   final bool canOverflow;
//   const SetSideBarOverflowMode(this.canOverflow);
// }
