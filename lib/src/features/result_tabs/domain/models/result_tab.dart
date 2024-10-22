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

// class OpenResultTab extends ResultTab {
//   const OpenResultTab({
//     required super.title,
//     required super.id,
//     required this.source,
//   });

//   final ResultTabSource source;
// }

// abstract class ResultTabSource {}

// class ResultTabSourceLocal extends ResultTabSource {
//   final String path;
//   ResultTabSourceLocal(this.path);
// }

// enum ResultTabActionType { add, remvove }

// class ResultTabAction {
//   final ResultTabActionType type;
//   final ResultTab tab;

//   ResultTabAction(this.type, this.tab);
// }
