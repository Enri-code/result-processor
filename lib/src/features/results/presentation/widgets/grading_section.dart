part of '../pages/pluto_grid_grading_page.dart';

abstract class ColumnKeys {
  static const studentName = 'student_name';
  static const regNo = 'reg_no';
  static const test = 'test';
  static const exam = 'exam';
  static const total = 'total';
  static const grade = 'grade';
}

final List<PlutoColumn> _gridColumns = [
  PlutoColumn(
    title: 'Student Name',
    field: ColumnKeys.studentName,
    type: PlutoColumnType.text(),
    cellPadding: const EdgeInsets.all(2),
    enableAutoEditing: true,
    enableRowDrag: true,
    minWidth: 170,
    width: 300,
  ),
  PlutoColumn(
    title: 'Reg NO.',
    field: ColumnKeys.regNo,
    type: PlutoColumnType.text(),
    enableAutoEditing: true,
    enableContextMenu: false,
    minWidth: 100,
    width: 200,
  ),
  PlutoColumn(
    title: 'Test',
    field: ColumnKeys.test,
    type: PlutoColumnType.text(),
    textAlign: PlutoColumnTextAlign.center,
    enableAutoEditing: true,
    enableContextMenu: false,
    minWidth: 60,
    width: 100,
  ),
  PlutoColumn(
    title: 'Exam',
    field: ColumnKeys.exam,
    type: PlutoColumnType.text(),
    textAlign: PlutoColumnTextAlign.center,
    enableAutoEditing: true,
    enableContextMenu: false,
    minWidth: 60,
    width: 100,
  ),
  PlutoColumn(
    title: 'Total',
    field: ColumnKeys.total,
    type: PlutoColumnType.text(),
    textAlign: PlutoColumnTextAlign.center,
    enableContextMenu: false,
    readOnly: true,
    minWidth: 60,
    width: 100,
  ),
  PlutoColumn(
    title: 'Grade',
    field: ColumnKeys.grade,
    type: PlutoColumnType.text(),
    textAlign: PlutoColumnTextAlign.center,
    enableContextMenu: false,
    enableDropToResize: false,
    readOnly: true,
    minWidth: 60,
    width: 100,
  ),
];

class _OptionsDropdownButton extends StatelessWidget {
  const _OptionsDropdownButton({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        showCustomMenu(
          context,
          position: event.position,
          items: [
            PopupMenuItem(
              height: 36,
              child: const Text('Delete row', style: TextStyle(fontSize: 13)),
              onTap: () {
                context.read<EditResultBloc>().add(
                      RemoveRowsEvent(indexes: [index]),
                    );
              },
            ),
            PopupMenuItem(
              height: 36,
              child: const Text(
                'Insert row above',
                style: TextStyle(fontSize: 13),
              ),
              onTap: () {
                context.read<EditResultBloc>().add(
                      InsertRowsEvent(index: index),
                    );
              },
            ),
            PopupMenuItem(
              height: 36,
              child: const Text(
                'Insert row below',
                style: TextStyle(fontSize: 13),
              ),
              onTap: () {
                context.read<EditResultBloc>().add(
                      InsertRowsEvent(index: index + 1),
                    );
              },
            ),
          ],
        );
      },
      child: const Center(
        child: Icon(Icons.more_vert, color: Colors.grey, size: 16),
      ),
    );
  }
}

class _GradingSection extends StatefulWidget {
  const _GradingSection();

  @override
  State<_GradingSection> createState() => _GradingSectionState();
}

class _GradingSectionState extends State<_GradingSection> {
  final externalScroll = ScrollController();
  PlutoGridStateManager? stateManager;

  @override
  void dispose() {
    externalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const rowHeight = 30.0, columnHeight = 34.0;
    const rowTextStyle = TextStyle(fontSize: 11, color: Colors.black);

    return BlocListener<EditResultBloc, EditResultState>(
      listenWhen: (p, c) => c.modifyGridEvent != null,
      listener: (context, state) {
        state.modifyGridEvent!.onModify(state, stateManager!);
      },
      child: BlocBuilder<EditResultBloc, EditResultState>(
        builder: (context, state) {
          final rowCount = state.rows.length;
          final height = 5 + columnHeight + (rowHeight + 1) * rowCount;
          return SizedBox(
            height: height,
            child: BlocSelector<ResultTabBloc, ResultTabState, ResultTab?>(
              selector: (state) => state.getCurrentTab,
              builder: (context, getCurrentTab) {
                return Row(
                  children: [
                    SizedBox(
                      width: 26,
                      child: Column(
                        children: [
                          const SizedBox(height: columnHeight + 2.6),
                          Expanded(
                            child: ScrollConfiguration(
                              behavior:
                                  ScrollConfiguration.of(context).copyWith(
                                scrollbars: false,
                              ),
                              child: ListView.builder(
                                key: ValueKey(getCurrentTab),
                                controller: externalScroll,
                                itemCount: rowCount,
                                itemBuilder: (context, i) {
                                  return SizedBox(
                                    height: rowHeight + 1,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme: const InputDecorationTheme(),
                        ),
                        child: PlutoGrid(
                          key: ValueKey(getCurrentTab),
                          rows: List.of(state.rows),
                          columns: _gridColumns,
                          configuration: const PlutoGridConfiguration(
                            enterKeyAction:
                                PlutoGridEnterKeyAction.editingAndMoveRight,
                            tabKeyAction:
                                PlutoGridTabKeyAction.moveToNextOnEdge,
                            columnSize: PlutoGridColumnSizeConfig(
                              autoSizeMode: PlutoAutoSizeMode.scale,
                              resizeMode: PlutoResizeMode.pushAndPull,
                            ),
                            style: PlutoGridStyleConfig(
                              iconSize: 12,
                              rowHeight: rowHeight,
                              columnHeight: columnHeight,
                              enableGridBorderShadow: true,
                              enableRowColorAnimation: true,
                              enableColumnBorderVertical: false,
                              gridBorderColor: Colors.transparent,
                              gridBackgroundColor: AppColor.lightGrey2,
                              cellColorInReadOnlyState: Colors.transparent,
                              cellTextStyle: rowTextStyle,
                              columnTextStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                              gridBorderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              gridPopupBorderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          onLoaded: (PlutoGridOnLoadedEvent event) {
                            setupGrid(event.stateManager, rowCount);
                          },
                          onChanged: _onChanged,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 26,
                      child: Column(
                        children: [
                          const SizedBox(height: columnHeight + 2.6),
                          Expanded(
                            child: ScrollConfiguration(
                              behavior:
                                  ScrollConfiguration.of(context).copyWith(
                                scrollbars: false,
                              ),
                              child: ListView.builder(
                                key: ValueKey(getCurrentTab),
                                itemCount: rowCount,
                                controller: externalScroll,
                                itemBuilder: (context, i) {
                                  return SizedBox(
                                    height: rowHeight + 1,
                                    child: _OptionsDropdownButton(index: i),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void setupGrid(PlutoGridStateManager stateManager, int rowCount) {
    if (!mounted) return;
    this.stateManager = stateManager;

    ///track grid vertical scroll with number scroll
    stateManager.scroll.bodyRowsVertical?.addListener(() {
      final offset = stateManager.scroll.bodyRowsVertical?.offset ?? 0;
      externalScroll.jumpTo(offset);
    });

    rowCount = max(100 - rowCount, 0);

    ///insert new empty rows if table has no rows already
    final editResultBloc = context.read<EditResultBloc>()
      ..add(InsertRowsEvent(count: rowCount));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ///calculate row data [total and grade] for each row
      for (var row in editResultBloc.state.rows) {
        editResultBloc.add(CalculateRowData(row));
      }
    });
  }

  void _onChanged(PlutoGridOnChangedEvent event) {
    if (event.value != null && event.value != '') {
      void onError(String mssg) {
        context.read<EditResultBloc>().add(
              UpdateCellData(event.rowIdx, event.column.field, ''),
            );
        ScaffoldMessenger.of(context).clearSnackBars();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showSnackBar(context, mssg);
        });
      }

      if (event.rowIdx > stateManager!.rows.length - 15) {
        context.read<EditResultBloc>().add(const InsertRowsEvent());
        stateManager!.scroll.bodyRowsVertical?.jumpTo(
          stateManager!.scroll.bodyRowsVertical!.position.maxScrollExtent,
        );
      }
      switch (event.column.field) {
        case ColumnKeys.test:
          final val = num.tryParse(event.value);
          if (val == null) {
            onError('Only numbers are allowed in Test score');
          } else if (val > 30) {
            onError('Test score cannot be more than 30');
          }
          context.read<EditResultBloc>().add(CalculateRowData(event.row));
          break;
        case ColumnKeys.exam:
          final val = num.tryParse(event.value);
          if (val == null) {
            onError('Only numbers are allowed in Exam score');
          } else if (val > 70) {
            onError('Exam score cannot be more than 70');
          }
          context.read<EditResultBloc>().add(CalculateRowData(event.row));
          break;
        default:
      }
    }
  }
}
