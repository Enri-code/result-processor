part of 'search_result_bloc.dart';

sealed class SearchResultEvent extends Equatable {
  const SearchResultEvent();

  @override
  List<Object> get props => [];
}

class SearchRegNumberResultEvent extends SearchResultEvent {
  const SearchRegNumberResultEvent(this.data);
  final SearchResultByRegistration data;
}

class SearchCourseCodeResultEvent extends SearchResultEvent {
  const SearchCourseCodeResultEvent(this.data);
  final SearchResultByCourse data;
}
