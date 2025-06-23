import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masakio/data/func_forum.dart';

part 'package:masakio/Forum/forum_state.dart';

class ForumCubit extends Cubit<ForumState> {
  ForumCubit() : super(ForumLoading());

  void fetchAllForums() async {
    try {
      emit(ForumLoading());
      final forums = await  fetchForums();
      emit(ForumLoaded(forums));
    } catch (e) { emit(ForumError(e.toString())); }
  }

  void refresh() => fetchAllForums();
}
