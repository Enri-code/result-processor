import 'package:flutter/material.dart';

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
