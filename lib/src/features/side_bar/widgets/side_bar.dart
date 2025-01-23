import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/features/results/domain/models/result_tab.dart';
import 'package:unn_grading/src/features/results/presentation/bloc/result_tab_bloc/result_tab_bloc.dart';
import 'package:unn_grading/src/features/side_bar/widgets/result_tabs.dart';
import 'package:unn_grading/src/features/side_bar/side_bar_bloc/side_bar_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class MySideBarTheme {
  final TextStyle? textStyle;
  final IconThemeData? iconTheme;

  const MySideBarTheme({this.textStyle, this.iconTheme});
}

class MySideBar extends StatelessWidget {
  const MySideBar({
    super.key,
    // required this.items,
    required this.expandedWidth,
    required this.width,
    required this.child,
    this.theme,
  });

  // final List<MySideBarItem> items;
  final MySideBarTheme? theme;
  final double expandedWidth, width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SideBarBloc(),
      child: LayoutBuilder(builder: (context, constraints) {
        bool csnShrink = constraints.maxWidth < 760;
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
                            child: const DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                              child: _TabsSection(),
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

class _LogoBanner extends StatelessWidget {
  const _LogoBanner();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse('https://techsalis.com/'));
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black26)],
        ),
        child: const Row(
          children: [
            Image(width: 22, image: AssetImage('assets/images/techsalis.png')),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('   Powered by', style: TextStyle(fontSize: 8.5)),
                Text(
                  '  TechSalis.',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      controller: scroll,
                      itemCount: state.length,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        final tab = state[index];
                        return ResultTabWiget(key: ValueKey(tab), tab: tab);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 12);
                      },
                    ),
                  ),
                  const _LogoBanner(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
