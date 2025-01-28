import 'package:equatable/equatable.dart';

abstract class ResultTab extends Equatable {
  final String id;
  final String? title;

  const ResultTab({this.title, required this.id});

  @override
  List<Object> get props => [id];
}

class NewResultTab extends ResultTab {
  const NewResultTab({super.title, required super.id});
}

class SavedResultTab extends ResultTab {
  final int? resultId;
  const SavedResultTab({super.title, required super.id, this.resultId});
}
