import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/domain/models/result.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';

part 'search_result_event.dart';
part 'search_result_state.dart';

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  final ResultRepository repo;
  SearchResultBloc(this.repo) : super(SearchResultInitialState()) {
    on<SearchForResultEvent>((event, emit) async {
      emit(SearchResultLoadingState(results: state.results));

      Either<RequestError, List<Result>>? response;

      if (event.data is SearchResultByRegistration) {
        response = await repo.searchByRegNo(
          event.data as SearchResultByRegistration,
        );
      } else if (event is SearchResultByCourse) {
        response = await repo.searchByCourse(
          event.data as SearchResultByCourse,
        );
      }

      response?.fold((left) {
        emit(SearchResultErrorState(left));
      }, (right) {
        emit(SearchResultFoundState(results: right));
      });
    });

    on<OpenSearchResultEvent>((event, emit) async {
      emit(SearchResultOpeningState(results: state.results));

      final response = await repo.openResult(event.data.id!);

      response.fold((left) {
        emit(SearchResultErrorState(left, results: state.results));
      }, (right) {
        emit(SearchResultOpenedState(right, results: state.results));
      });
    });
  }
}
