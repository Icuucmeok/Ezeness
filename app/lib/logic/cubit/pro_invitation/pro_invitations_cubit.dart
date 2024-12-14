import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/invite_user/invite_user_list.dart';
import 'package:ezeness/data/repositories/invite_user_repository.dart';

part 'pro_invitations_state.dart';

class ProInvitationsCubit extends Cubit<ProInvitationsState> {
  final InviteUserRepository _inviteUserRepository;
  ProInvitationsCubit(this._inviteUserRepository)
      : super(ProInvitationsInitial());

  void getProInvitation() async {
    emit(ProInvitationsLoading());
    try {
      final data = await _inviteUserRepository.getProInvitation();
      emit(ProInvitationsLoaded(data!));
    } catch (e) {
      emit(ProInvitationsFailure(e));
    }
  }

  void toggleProInvitationStatus(int id) async {
    emit(ProInvitationsLoading());
    try {
      final data = await _inviteUserRepository.toggleProInvitationStatus(id);
      emit(ToggleProInvitationStatusDone(data!));
    } catch (e) {
      emit(ProInvitationsFailure(e));
    }
  }

  void sendProInvite({required String title}) async {
    emit(ProInvitationsLoading());
    try {
      final data = await _inviteUserRepository.sendProInvite(title: title);
      emit(SendProInvitationsDone(data!));
    } catch (e) {
      emit(ProInvitationsFailure(e));
    }
  }
}
