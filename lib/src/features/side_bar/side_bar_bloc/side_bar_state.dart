part of 'side_bar_bloc.dart';

class SideBarState extends Equatable {
  const SideBarState({
    this.expanded = false,
    // this.canOverflow = true,
    this.canShrink = true,
  });

  final bool expanded;
  // final bool canOverflow;
  final bool canShrink;

  @override
  List<Object?> get props => [expanded, canShrink];

  SideBarState copyWith({
    bool? expanded,
    // bool? canOverflow,
    bool? canShrink,
  }) {
    return SideBarState(
      expanded: expanded ?? this.expanded,
      // canOverflow: canOverflow ?? this.canOverflow,
      canShrink: canShrink ?? this.canShrink,
    );
  }
}
