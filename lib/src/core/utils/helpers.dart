import 'package:flutter/material.dart';

const widthSpacing = SizedBox(width: 8);
const heightSpacing = SizedBox(height: 8);

Future<dynamic> showCustomMenu(
  BuildContext context, {
  required Offset position,
  required List<PopupMenuEntry<dynamic>> items,
}) {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

  return showMenu(
    context: context,
    color: Colors.white,
    position: RelativeRect.fromLTRB(
      position.dx - 160,
      position.dy,
      position.dx + overlay.size.width,
      position.dy + overlay.size.height,
    ),
    items: items,
  );
}

void showSnackBar(BuildContext context, String message, {bool isError = true}) {
  if (message.isEmpty) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, overflow: TextOverflow.ellipsis, maxLines: 2),
    elevation: 8,
    showCloseIcon: true,
    backgroundColor: isError ? Colors.red : Colors.green,
    behavior: SnackBarBehavior.fixed,
  ));
}

String? sessionTFValidator(String? value, [bool isRequired = true]) {
  if (value!.isEmpty && !isRequired) return null;
  if (!RegExp(r"^\d{4}-\d{4}$").hasMatch(value)) {
    return '';
  } else {
    final yearDiff = value.split('-').fold(0, (p, e) {
      return int.parse(e) - p;
    });
    if (yearDiff != 1) return '';
  }
  return null;
}
