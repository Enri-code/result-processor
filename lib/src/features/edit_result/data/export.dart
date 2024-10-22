import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart';
import 'package:unn_grading/src/features/edit_result/domain/export.dart';

class ExportPDFResult extends ExportPlutoGridResult {
  ExportPDFResult(super.stateManager);

  @override
  Future export() async {
    final plutoGridPdfExport = PlutoGridDefaultPdfExport(
      title: title,
      creator: "Result Processor",
      format: PdfPageFormat.a4.landscape,
    );
    final bytes = await plutoGridPdfExport.export(stateManager);

    await _saveFileTo(name: title, bytes: bytes, extension: "pdf");
  }
}

class ExportCSVResult extends ExportPlutoGridResult {
  ExportCSVResult(super.stateManager);

  @override
  Future export() async {
    final bytes = const Utf8Encoder().convert(
      PlutoGridExport.exportCSV(stateManager),
    );
    await _saveFileTo(name: title, bytes: bytes, extension: "csv");
  }
}

Future<bool?> _saveFileTo({
  required String name,
  required Uint8List bytes,
  required String extension,
}) async {
  String? outputFile = await FilePicker.platform.saveFile(
    initialDirectory: await getDownloadsDirectory().then((d) => d?.path),
    dialogTitle: 'Choose file location',
    allowedExtensions: [extension],
    fileName: '$name.$extension',
    type: FileType.custom,
    lockParentWindow: true,
  );

  if (outputFile == null) return null;

  try {
    await File(outputFile).writeAsBytes(bytes);
    return true;
  } catch (e) {
    return false;
  }
}
