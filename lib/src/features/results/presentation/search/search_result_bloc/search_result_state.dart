part of 'search_result_bloc.dart';

sealed class SearchResultState extends Equatable {
  const SearchResultState();

  @override
  List<Object> get props => [];
}

final class SearchResultInitialState extends SearchResultState {}

final class SearchResultLoadingState extends SearchResultState {}

final class SearchResultErrorState extends SearchResultState {
  final RequestError error;
  const SearchResultErrorState(this.error);
}

final class SearchResultFoundState extends SearchResultState {
  final List results;

  const SearchResultFoundState(this.results);
}
