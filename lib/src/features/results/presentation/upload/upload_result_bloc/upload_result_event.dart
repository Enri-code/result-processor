part of 'upload_result_bloc.dart';

sealed class UploadResultEvent extends Equatable {
  const UploadResultEvent();

  @override
  List<Object> get props => [];
}

class PickResultFileEvent extends UploadResultEvent {
  final File? file;
  final String? fileName;

  const PickResultFileEvent([this.file, this.fileName]);
}

class UploadResultFileEvent extends UploadResultEvent {
  const UploadResultFileEvent();
}

class RemoveResultFileEvent extends UploadResultEvent {
  const RemoveResultFileEvent();
}

class SetResultFileTypeEvent extends UploadResultEvent {
  final ResultFileType fileType;
  const SetResultFileTypeEvent(this.fileType);
}
