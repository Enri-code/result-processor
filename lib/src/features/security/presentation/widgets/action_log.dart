import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:unn_grading/src/features/security/domain/models/log_data.dart';

class ActivityLogWidget extends StatefulWidget {
  const ActivityLogWidget({super.key, required this.data});
  final ActivityLog data;

  @override
  State<ActivityLogWidget> createState() => _ActivityLogWidgetState();
}

class _ActivityLogWidgetState extends State<ActivityLogWidget> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.data.resource,
                    style: const TextStyle(fontSize: 11),
                  ),
                  Text(
                    '${widget.data.username}: ID(${widget.data.userId})',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Action', style: TextStyle(fontSize: 11)),
                  Text(
                    widget.data.action,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.data.time != null)
                    Text(
                      Jiffy.parseFromDateTime(widget.data.time!).fromNow(),
                      style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
