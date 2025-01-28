part of 'open_result_bloc.dart';

sealed class OpenResultState extends Equatable {
  const OpenResultState({this.results = const []});
  final List<Result> results;

  @override
  List<Object> get props => [results];
}

final class OpenResultInitialState extends OpenResultState {}

final class SearchResultErrorState extends OpenResultState {
  final RequestError error;
  const SearchResultErrorState(this.error, {super.results});
}

final class SearchResultLoadingState extends OpenResultState {
  const SearchResultLoadingState({super.results});
}

final class SearchResultFoundState extends OpenResultState {
  const SearchResultFoundState({super.results});
}

final class ResultOpeningState extends OpenResultState {
  const ResultOpeningState({super.results});
}

final class ResultOpenedState extends OpenResultState {
  const ResultOpenedState(this.data, {super.results});
  final ResultData data;
}
