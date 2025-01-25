part of 'search_result_bloc.dart';

sealed class SearchResultState extends Equatable {
  const SearchResultState({this.results = const []});
  final List<Result> results;

  @override
  List<Object> get props => [results];
}

final class SearchResultInitialState extends SearchResultState {}

final class SearchResultErrorState extends SearchResultState {
  final RequestError error;
  const SearchResultErrorState(this.error, {super.results});
}

final class SearchResultLoadingState extends SearchResultState {
  const SearchResultLoadingState({super.results});
}

final class SearchResultFoundState extends SearchResultState {
  const SearchResultFoundState({super.results});
}

final class SearchResultOpeningState extends SearchResultState {
  const SearchResultOpeningState({super.results});
}

final class SearchResultOpenedState extends SearchResultState {
  const SearchResultOpenedState(this.data, {super.results});
  final ResultData data;
}
