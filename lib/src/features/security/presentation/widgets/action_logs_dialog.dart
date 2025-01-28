import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/helpers.dart';
import 'package:unn_grading/src/features/security/presentation/security_bloc/security_bloc.dart';
import 'package:unn_grading/src/features/security/presentation/widgets/action_log.dart';

class ActionLogsDialog extends StatelessWidget {
  const ActionLogsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Scaffold(
        backgroundColor: Colors.brown[700],
        body: Column(
          children: [
            heightSpacing,
            const Text(
              'ACTIVITY LOGS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(
              child: Card(
                elevation: 4,
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<SecurityBloc, SecurityState>(
                        builder: (context, state) {
                          return ListView.separated(
                            itemCount: state.logs.length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, i) {
                              if (state.page > 0 &&
                                  i + 1 == state.logs.length) {
                                context.read<SecurityBloc>().add(
                                      const GetActivityLogsEvent(),
                                    );
                              }
                              return ActivityLogWidget(data: state.logs[i]);
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(height: 1);
                            },
                          );
                        },
                      ),
                    ),
                    const Divider(height: 0),
                    heightSpacing,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                      child: Row(
                        children: [
                          BlocBuilder<SecurityBloc, SecurityState>(
                            builder: (context, state) {
                              if (state is SecurityLogsLoadingState) {
                                return const Row(
                                  children: [
                                    SizedBox.square(
                                      dimension: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text('Loading...'),
                                  ],
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                          const Spacer(),
                          TextButton(
                            style: const ButtonStyle(
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.red,
                              ),
                            ),
                            child: const Text('Close'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
