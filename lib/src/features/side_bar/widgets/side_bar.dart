import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/constants/app_color.dart';
import 'package:unn_grading/src/features/result_tabs/domain/models/result_tab.dart';
import 'package:unn_grading/src/features/result_tabs/presentation/result_tab_bloc/result_tab_bloc.dart';
import 'package:unn_grading/src/features/side_bar/widgets/result_tabs.dart';
import 'package:unn_grading/src/features/side_bar/side_bar_bloc/side_bar_bloc.dart';

class MySideBarItem extends Equatable {
  final IconData icon;
  final String label;
  final bool enabled;
  final void Function(PointerUpEvent)? onPointerUp;

  const MySideBarItem({
    required this.icon,
    required this.label,
    this.onPointerUp,
    this.enabled = true,
  });

  @override
  List<Object?> get props => [icon, label];
}

class MySideBarTheme {
  final TextStyle? textStyle;
  final IconThemeData? iconTheme;

  const MySideBarTheme({this.textStyle, this.iconTheme});
}

class MySideBar extends StatelessWidget {
  const MySideBar({
    super.key,
    required this.items,
    required this.expandedWidth,
    required this.width,
    required this.child,
    this.theme,
  });

  final List<MySideBarItem> items;
  final MySideBarTheme? theme;
  final double expandedWidth, width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SideBarBloc(),
      child: LayoutBuilder(builder: (context, constraints) {
        bool csnShrink = constraints.maxWidth < 710;
        context.read<SideBarBloc>().add(SetSideBarShrinkMode(csnShrink));

        return BlocSelector<SideBarBloc, SideBarState, bool>(
          selector: (state) => state.expanded || !state.canShrink,
          builder: (context, expanded) {
            final row = Row(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: Theme.of(context).iconTheme.merge(
                          theme?.iconTheme,
                        ),
                  ),
                  child: DefaultTextStyle(
                    style: theme?.textStyle ??
                        const TextStyle(fontSize: 12, color: Colors.black),
                    child: AnimatedSize(
                      curve: Curves.easeOut,
                      duration: Durations.medium1,
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: expanded ? expandedWidth : width,
                        child: MouseRegion(
                          onHover: (event) {
                            if (!csnShrink) return;
                            context.read<SideBarBloc>().add(
                                  const ExpandSideBarEvent(true),
                                );
                          },
                          onExit: (event) {
                            if (!csnShrink) return;
                            context.read<SideBarBloc>().add(
                                  const ExpandSideBarEvent(false),
                                );
                          },
                          child: OverflowBox(
                            maxWidth: expandedWidth,
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                ...List.generate(
                                  items.length,
                                  (i) => _OptionWidget(item: items[i]),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 1,
                                  width: expandedWidth - 4,
                                  margin: const EdgeInsets.only(left: 4),
                                  color: Colors.grey,
                                ),
                                const DefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                  child: Expanded(child: _TabsSection()),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Durations.short2,
                  width: constraints.maxWidth -
                      (!csnShrink ? expandedWidth : width),
                  child: child,
                ),
              ],
            );
            return OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment.centerLeft,
              child: row,
            );
          },
        );
      }),
    );
  }
}

class _TabsSection extends StatefulWidget {
  const _TabsSection();

  @override
  State<_TabsSection> createState() => _TabsSectionState();
}

class _TabsSectionState extends State<_TabsSection> {
  final scroll = ScrollController();

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: const ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(Colors.grey),
      ),
      child: Scrollbar(
        thickness: 4,
        controller: scroll,
        scrollbarOrientation: ScrollbarOrientation.left,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: BlocSelector<ResultTabBloc, ResultTabState, List<ResultTab>>(
            selector: (state) => state.resultTabs,
            builder: (context, state) {
              return ListView.separated(
                controller: scroll,
                itemCount: state.length,
                padding: const EdgeInsets.symmetric(vertical: 24),
                itemBuilder: (context, index) {
                  final tab = state[index];
                  return ResultTabWiget(key: ValueKey(tab), tab: tab);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OptionWidget extends StatefulWidget {
  const _OptionWidget({required this.item});

  final MySideBarItem item;

  @override
  State<_OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<_OptionWidget> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Builder(builder: (context) {
        final child = Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Icon(
                widget.item.icon,
                color: hovered ? AppColor.primary : null,
              ),
              const SizedBox(width: 8),
              BlocSelector<SideBarBloc, SideBarState, bool>(
                selector: (state) => state.expanded || !state.canShrink,
                builder: (context, expanded) {
                  return AnimatedOpacity(
                    duration: Durations.medium2,
                    opacity: expanded ? 1 : 0,
                    child: Text(
                      widget.item.label,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: hovered ? AppColor.primary : null,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
        if (!widget.item.enabled) return Opacity(opacity: 0.6, child: child);

        return Listener(
          onPointerUp: widget.item.onPointerUp,
          behavior: HitTestBehavior.opaque,
          child: MouseRegion(
            onHover: (event) => setState(() => hovered = true),
            onExit: (event) => setState(() => hovered = false),
            child: child,
          ),
        );
      }),
    );
  }
}
