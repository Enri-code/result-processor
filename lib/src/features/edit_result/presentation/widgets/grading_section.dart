part of '../pages/pluto_grid_grading_page.dart';

abstract class ColumnKeys {
  static const fullname = 'full_name';
  static const studentId = 'student_id';
  static const test = 'test';
  static const exam = 'exam';
  static const total = 'total';
  static const grade = 'grade';
}

final List<PlutoColumn> _gridColumns = [
  PlutoColumn(
    title: 'Full Name',
    field: ColumnKeys.fullname,
    type: PlutoColumnType.text(),
    cellPadding: const EdgeInsets.all(2),
    enableAutoEditing: true,
    enableRowDrag: true,
    minWidth: 170,
    width: 300,
  ),
  PlutoColumn(
    title: 'Student ID',
    field: ColumnKeys.studentId,
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

class _GridSection extends StatefulWidget {
  const _GridSection();

  @override
  State<_GridSection> createState() => _GridSectionState();
}

class _GridSectionState extends State<_GridSection> {
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
          final height =
              5 + columnHeight + (rowHeight + 1) * rowCount.toDouble();
          return SizedBox(
            height: height,
            child: Row(
              children: List.of([
                SizedBox(
                  width: 26,
                  child: Column(
                    children: [
                      const SizedBox(height: columnHeight + 2.6),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false,
                          ),
                          child: ListView.builder(
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
                  child:
                      BlocSelector<ResultTabBloc, ResultTabState, ResultTab?>(
                    selector: (state) => state.getCurrentTab,
                    builder: (context, getCurrentTab) {
                      return PlutoGrid(
                        key: ValueKey(getCurrentTab),
                        rows: List.from(state.rows),
                        columns: _gridColumns,
                        configuration: const PlutoGridConfiguration(
                          enterKeyAction:
                              PlutoGridEnterKeyAction.editingAndMoveRight,
                          tabKeyAction: PlutoGridTabKeyAction.moveToNextOnEdge,
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
                          setupGrid(event.stateManager);
                        },
                        onChanged: _onChanged,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 26,
                  child: Column(
                    children: [
                      const SizedBox(height: columnHeight + 2.6),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false,
                          ),
                          child: ListView.builder(
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
              ], growable: false),
            ),
          );
        },
      ),
    );
  }

  void setupGrid(PlutoGridStateManager stateManager) {
    if (!mounted) return;
    this.stateManager = stateManager;

    ///track grid vertical scroll with number scroll
    stateManager.scroll.bodyRowsVertical?.addListener(() {
      final offset = stateManager.scroll.bodyRowsVertical?.offset ?? 0;
      externalScroll.jumpTo(offset);
    });

    final editResultBloc = context.read<EditResultBloc>();
    if (editResultBloc.state.rows.isEmpty) {
      // if (kDebugMode) {
      //   final rowsToBeAdded = List.generate(Random().nextInt(10), (_) {
      //     return PlutoRow(cells: {
      //       ColumnKeys.fullname: PlutoCell(value: ''),
      //       ColumnKeys.studentId: PlutoCell(value: ''),
      //       ColumnKeys.test: PlutoCell(value: Random().nextInt(30)),
      //       ColumnKeys.exam: PlutoCell(value: Random().nextInt(70)),
      //       ColumnKeys.total: PlutoCell(value: ''),
      //       ColumnKeys.grade: PlutoCell(value: ''),
      //     });
      //   });
      //   editResultBloc.add(InsertRowsEvent(rows: rowsToBeAdded));
      // }

      ///insert new empty rows if table has no rows already
      editResultBloc.add(const InsertRowsEvent(count: 100));
    }

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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(mssg, overflow: TextOverflow.ellipsis, maxLines: 1),
            elevation: 8,
            showCloseIcon: true,
            backgroundColor: AppColor.error,
            behavior: SnackBarBehavior.fixed,
          ));
        });
      }

      if (event.rowIdx > stateManager!.rows.length - 3) {
        context.read<EditResultBloc>().add(const InsertRowsEvent());
        stateManager!.scroll.bodyRowsVertical?.jumpTo(
          stateManager!.scroll.bodyRowsVertical!.position.maxScrollExtent,
        );
      }
      switch (event.column.field) {
        case ColumnKeys.test:
          final val = num.tryParse(event.value);
          if (val == null) {
            onError('Only numbers allowed in C.A.');
          } else if (val > 30) {
            onError('C.A. cannot be more than 30');
          }
          context.read<EditResultBloc>().add(CalculateRowData(event.row));
          break;
        case ColumnKeys.exam:
          final val = num.tryParse(event.value);
          if (val == null) {
            onError('Only numbers allowed in Exam');
          } else if (num.parse(event.value) > 70) {
            onError('Exam cannot be more than 70');
          }
          context.read<EditResultBloc>().add(CalculateRowData(event.row));
          break;
        default:
      }
    }
  }
}
