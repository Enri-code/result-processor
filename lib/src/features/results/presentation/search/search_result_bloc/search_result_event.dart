part of 'search_result_bloc.dart';

sealed class SearchResultEvent extends Equatable {
  const SearchResultEvent();

  @override
  List<Object> get props => [];
}

class OpenSearchResultEvent extends SearchResultEvent {
  const OpenSearchResultEvent(this.data);
  final Result data;
}

class SearchForResultEvent extends SearchResultEvent {
  const SearchForResultEvent(this.data);
  final SearchResult data;
}
