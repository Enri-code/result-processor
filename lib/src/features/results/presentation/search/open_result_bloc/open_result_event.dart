part of 'open_result_bloc.dart';

sealed class OpenResultEvent extends Equatable {
  const OpenResultEvent();

  @override
  List<Object> get props => [];
}

class GetSavedResultsEvent extends OpenResultEvent {
  const GetSavedResultsEvent();
}

class OpenSearchResultEvent extends OpenResultEvent {
  const OpenSearchResultEvent(this.data);
  final Result data;
}

class SearchForResultEvent extends OpenResultEvent {
  const SearchForResultEvent(this.data);
  final SearchResult data;
}

// class SearchResultByRegNoEvent extends OpenResultEvent {
//   const SearchResultByRegNoEvent(this.regNo, this.session);
//   final String regNo, session;
// }
