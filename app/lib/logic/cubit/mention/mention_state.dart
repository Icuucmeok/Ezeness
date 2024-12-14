part of 'mention_cubit.dart';


abstract class MentionState extends Equatable {
  const MentionState();

  @override
  List<Object> get props => [];
}

class MentionInitial extends MentionState {}

class MentionLoading extends MentionState {}
class MentionFailure extends MentionState {
  final Object exception;

  const MentionFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class MentionLoaded extends MentionState {
  final UserList response;

  const MentionLoaded(this.response);
  @override
  List<Object> get props => [response];

}










