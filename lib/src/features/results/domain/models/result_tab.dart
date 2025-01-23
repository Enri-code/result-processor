import 'package:equatable/equatable.dart';

abstract class ResultTab extends Equatable {
  final String? title;
  final String id;

  const ResultTab({this.title, required this.id});

  @override
  List<Object> get props => [id];
}

class NewResultTab extends ResultTab {
  const NewResultTab({super.title, required super.id});
}
