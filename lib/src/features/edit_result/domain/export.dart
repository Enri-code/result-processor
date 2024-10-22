import 'package:pluto_grid/pluto_grid.dart';

abstract class ExportPlutoGridResult {
  final String title;
  final PlutoGridStateManager stateManager;
  ExportPlutoGridResult(this.stateManager, {this.title = 'Result Processor'});

  void export();
}
