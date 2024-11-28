import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'hashtag_mentions_text_field_states.dart';

class HashtagMentionsTextFieldCubit
    extends Cubit<HashtagMentionsTextFieldStates> {
  HashtagMentionsTextFieldCubit() : super(HashTagsActiveState());

  void setMentionsActive() {
    emit(MentionsActiveState());
  }

  void setHashtagsActive() {
    emit(HashTagsActiveState());
  }
}
