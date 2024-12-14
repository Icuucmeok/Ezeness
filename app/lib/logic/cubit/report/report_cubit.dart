import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/post_repository.dart';
part 'report_state.dart';


class ReportCubit extends Cubit<ReportState> {
  final PostRepository _postRepository;
  ReportCubit(this._postRepository) : super(ReportInitial());


  void reportPost({required int postId,required int reasonId}) async {
    emit(ReportLoading());
    try {
     final data =  await _postRepository.reportPost(postId,reasonId);
     emit(ReportPostDone(data!));
    } catch (e) {
      emit(ReportFailure(e));
    }
  }
}
