import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/invite_credit/invite_credit_list.dart';
import '../../../data/models/invite_user/invite_user.dart';
import '../../../data/models/invite_user/invite_user_list.dart';

import '../../../data/repositories/invite_user_repository.dart';

part 'invite_user_state.dart';

class InviteUserCubit extends Cubit<InviteUserState> {
  final InviteUserRepository _inviteUserRepository;
  InviteUserCubit(this._inviteUserRepository) : super(InviteUserInitial());



  void getInvitation(int type) async {
    emit(InviteUserLoading());
    try {
      final data =  await _inviteUserRepository.getInvitation(type);
      emit(InvitationLoaded(data!));
    } catch (e) {
      emit(InviteUserFailure(e));
    }
  }

  void getInvitationCredit() async {
    emit(InviteUserLoading());
    try {
      final data =  await _inviteUserRepository.getInvitationCredit();
      emit(InvitationCreditLoaded(data!));
    } catch (e) {
      emit(InviteUserFailure(e));
    }
  }

  void sendInvite(InviteUser body) async {
    emit(InviteUserLoading());
    try {
      final data =  await _inviteUserRepository.sendInvite(body);
      emit(InviteUserDone(data!));
    } catch (e) {
      emit(InviteUserFailure(e));
    }
  }

  void deleteInvite(int id) async {
    emit(InviteUserLoading());
    try {
      final data =  await _inviteUserRepository.deleteInvite(id);
      emit(DeleteInviteDone(data!));
    } catch (e) {
      emit(InviteUserFailure(e));
    }
  }
}
