part of 'upload_result_bloc.dart';

enum ResultFileType { pdf }

sealed class UploadResultState extends Equatable {
  const UploadResultState({this.status, this.fileType = ResultFileType.pdf});

  final ResultFileType fileType;
  final RequestStatus? status;

  UploadResultState copyWith({RequestStatus? status});

  @override
  List<Object?> get props => [fileType, status];
}

final class UploadResultInitialState extends UploadResultState {
  const UploadResultInitialState({super.fileType});

  @override
  UploadResultState copyWith({RequestStatus? status}) {
    throw UnimplementedError();
  }
}

final class UploadResultPickedState extends UploadResultState {
  final File file;
  final String fileName;

  const UploadResultPickedState({
    required this.file,
    required this.fileName,
    super.status,
    super.fileType,
  });

  @override
  UploadResultState copyWith({RequestStatus? status}) {
    return UploadResultPickedState(
      status: status ?? this.status,
      file: file,
      fileName: fileName,
      fileType: fileType,
    );
  }

  @override
  List<Object?> get props => [file, fileName, fileType, status];
}

class ResultFileUploading extends RequestLoading {
  const ResultFileUploading();
}

class ResultFileUploaded extends RequestSuccess {
  const ResultFileUploaded();
}
