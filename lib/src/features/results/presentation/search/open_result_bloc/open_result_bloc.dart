import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/domain/models/result.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';

part 'open_result_event.dart';
part 'open_result_state.dart';

class OpenResultBloc extends Bloc<OpenResultEvent, OpenResultState> {
  final ResultRepository repo;
  OpenResultBloc(this.repo) : super(OpenResultInitialState()) {
    on<GetSavedResultsEvent>((event, emit) async {
      emit(SearchResultLoadingState(results: state.results));

      final response = await repo.search(SearchResult());

      response.fold((left) {
        emit(SearchResultErrorState(left));
      }, (right) {
        emit(SearchResultFoundState(results: right));
      });
    });
    on<SearchForResultEvent>((event, emit) async {
      emit(SearchResultLoadingState(results: state.results));

      final response = await repo.search(event.data);

      response.fold((left) {
        emit(SearchResultErrorState(left));
      }, (right) {
        emit(SearchResultFoundState(results: right));
      });
    });
    on<OpenSearchResultEvent>((event, emit) async {
      emit(ResultOpeningState(results: state.results));

      final response = await repo.openResult(event.data.id!);

      response.fold((left) {
        emit(SearchResultErrorState(left, results: state.results));
      }, (right) {
        emit(ResultOpenedState(right, results: state.results));
      });
    });
  }
}
