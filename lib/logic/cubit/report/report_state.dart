part of 'report_cubit.dart';


abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}
class ReportFailure extends ReportState {
  final Object exception;

  const ReportFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class ReportPostDone extends ReportState {
  final String response;

  const ReportPostDone(this.response);
  @override
  List<Object> get props => [response];

}




