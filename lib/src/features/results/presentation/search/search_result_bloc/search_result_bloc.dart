import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';

part 'search_result_event.dart';
part 'search_result_state.dart';

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  final ResultRepository repo;
  SearchResultBloc(this.repo) : super(SearchResultInitialState()) {
    on<SearchRegNumberResultEvent>((event, emit) async {
      emit(SearchResultLoadingState());
      final response = await repo.searchByRegNo(event.data);

      response.fold((left) {
        emit(SearchResultErrorState(left));
      }, (right) {
        // emit(SearchResultFoundState(right));
      });
    });
    on<SearchCourseCodeResultEvent>((event, emit) async {
      emit(SearchResultLoadingState());
      final response = await repo.searchByCourse(event.data);

      response.fold((left) {
        emit(SearchResultErrorState(left));
      }, (right) {
        // emit(SearchResultFoundState(right));
      });
    });
  }
}
