import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';

part 'upload_result_event.dart';
part 'upload_result_state.dart';

class UploadResultBloc extends Bloc<UploadResultEvent, UploadResultState> {
  final ResultRepository repo;

  UploadResultBloc(this.repo)
      : super(const UploadResultInitialState(
          fileType: ResultFileType.pdf,
        )) {
    on<PickResultFileEvent>((event, emit) async {
      File? file = event.file;
      String? fileName = event.fileName;

      if (file == null) {
        final pickedFiles = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [state.fileType.name],
        );

        if (pickedFiles != null) {
          fileName = pickedFiles.files.first.name;
          file = File(pickedFiles.files.first.path!);
        }
      }

      emit(UploadResultPickedState(file: file!, fileName: fileName!));
    });
    on<UploadResultFileEvent>((event, emit) async {
      emit(state.copyWith(status: const ResultFileUploading()));

      final response = await repo.upload(
        (state as UploadResultPickedState).file,
        (state as UploadResultPickedState).fileName,
      );

      response.fold(
        (left) {
          emit(state.copyWith(status: left));
        },
        (right) {
          emit(state.copyWith(status: const ResultFileUploaded()));
        },
      );
    });
    on<RemoveResultFileEvent>((event, emit) async {
      emit(UploadResultInitialState(fileType: state.fileType));
    });
    on<SetResultFileTypeEvent>((event, emit) async {
      emit(UploadResultInitialState(fileType: event.fileType));
    });
  }
}
