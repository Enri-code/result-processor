import 'package:flutter/material.dart';
import 'package:unn_grading/src/features/results/domain/models/result.dart';

class ResultItemWidget extends StatelessWidget {
  const ResultItemWidget({
    super.key,
    required this.result,
    required this.onTap,
  });

  final Result result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    result.courseCode,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (result.courseTitle.isNotEmpty)
                    Expanded(
                      child: Text(
                        '  -  ${result.courseTitle}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    )
                  else
                    const Spacer(),
                  if (result.semester.isNotEmpty)
                    Text(
                      '${result.semester} semester',
                      style: const TextStyle(fontSize: 10),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (result.department.isNotEmpty)
                    Text(
                      result.department,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  if (result.courseUnit != null)
                    Text(
                      ' - ${result.courseUnit} Units',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  const Spacer(),
                  if (result.session.isNotEmpty)
                    Text(
                      result.session,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
