import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:unn_grading/src/core/constants/app_color.dart';
import 'package:unn_grading/src/core/utils/helpers.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/presentation/upload/upload_result_bloc/upload_result_bloc.dart';

class DragTargetWidget extends StatefulWidget {
  const DragTargetWidget({super.key});

  @override
  State<DragTargetWidget> createState() => _DragTargetWidgetState();
}

class _DragTargetWidgetState extends State<DragTargetWidget> {
  bool _dragging = false;

  @override
  void initState() {
    final bloc = context.read<UploadResultBloc>();
    if (bloc.state.status is ResultFileUploaded) {
      bloc.add(const RemoveResultFileEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: _dragging ? AppColor.primary : Colors.black,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200, maxWidth: 400),
        child: Scaffold(
          body: BlocListener<UploadResultBloc, UploadResultState>(
            listener: (context, state) {
              if (state.status is RequestError) {
                showSnackBar(context, (state.status as RequestError).message);
              }
            },
            child: BlocConsumer<UploadResultBloc, UploadResultState>(
              listener: (context, state) {
                if (state.status is RequestSuccess) {
                  Future.delayed(
                      Durations.extralong4, Navigator.of(context).pop);
                }
              },
              builder: (context, state) {
                String getFileTypeName() {
                  if (state.fileType == ResultFileType.pdf) return 'PDF ';
                  return '';
                }

                getFileFormat() {
                  if (state.fileType == ResultFileType.pdf) return Formats.pdf;
                }

                return DropRegion(
                  formats: <DataFormat>[
                    if (getFileFormat() != null) getFileFormat()!,
                  ],
                  hitTestBehavior: HitTestBehavior.opaque,
                  onDropOver: (event) {
                    // You can inspect local data here, as well as formats of each item.
                    // However on certain platforms (mobile / web) the actual data is
                    // only available when the drop is accepted (onPerformDrop).
                    // This drop region only supports copy operation.
                    if (event.session.items.length > 1) {
                      return DropOperation.none;
                    }

                    if (event.session.allowedOperations.contains(
                      DropOperation.copy,
                    )) {
                      setState(() => _dragging = true);
                      return DropOperation.copy;
                    }
                    return DropOperation.none;
                  },
                  onDropLeave: (event) => setState(() => _dragging = false),
                  onPerformDrop: (event) async {
                    // Called when user dropped the item. You can now request the data.
                    // Note that data must be requested before the performDrop callback
                    // is over.
                    final reader = event.session.items.first.dataReader!;
                    reader.getFile(getFileFormat()!, (value) async {
                      final path = (await getTemporaryDirectory()).path;
                      final file = File(path + value.fileName!)
                        ..writeAsBytes(await value.readAll());

                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        context.read<UploadResultBloc>().add(
                              PickResultFileEvent(file, value.fileName),
                            );
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          color: Colors.red[900],
                          onPressed: () {
                            context.read<UploadResultBloc>().add(
                                  const RemoveResultFileEvent(),
                                );
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              size: 36,
                              color:
                                  _dragging || state is UploadResultPickedState
                                      ? AppColor.primary
                                      : Colors.black,
                            ),
                            const SizedBox(height: 20),
                            if (state is! UploadResultPickedState)
                              SizedBox(
                                height: 40,
                                child: Center(
                                  child: Text(
                                    "Drop your ${getFileTypeName()}file here, or",
                                  ),
                                ),
                              )
                            else
                              SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 12),
                                    Flexible(
                                      child: Text(
                                        state.fileName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (state.status is RequestLoading)
                                      const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: SizedBox.square(
                                          dimension: 16,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outlined,
                                          color: Colors.red[900],
                                        ),
                                        onPressed: () {
                                          context.read<UploadResultBloc>().add(
                                                const RemoveResultFileEvent(),
                                              );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 12),
                            if (state is UploadResultPickedState)
                              if (state.status is ResultFileUploading)
                                const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Text('Uploading File...'),
                                )
                              else if (state.status is ResultFileUploaded)
                                const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Text(
                                    'File Uploaded',
                                    style: TextStyle(color: AppColor.primary),
                                  ),
                                )
                              else
                                OutlinedButton(
                                  child: const Text('Upload File'),
                                  onPressed: () {
                                    context.read<UploadResultBloc>().add(
                                          const UploadResultFileEvent(),
                                        );
                                  },
                                )
                            else
                              TextButton(
                                child: const Text('Choose File'),
                                onPressed: () {
                                  context.read<UploadResultBloc>().add(
                                        const PickResultFileEvent(),
                                      );
                                },
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
