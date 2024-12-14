part of 'hashtag_mentions_text_field_cubit.dart';

abstract class HashtagMentionsTextFieldStates extends Equatable {
  const HashtagMentionsTextFieldStates();

  @override
  List<Object> get props => [];
}

class MentionsActiveState extends HashtagMentionsTextFieldStates {}

class HashTagsActiveState extends HashtagMentionsTextFieldStates {}
