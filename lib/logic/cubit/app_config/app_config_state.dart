part of 'app_config_cubit.dart';

class AppConfigState extends Equatable {
  final String languageCode;
  final User user;

  const AppConfigState({required this.languageCode, required this.user});

  @override
  List<Object> get props => [languageCode , user];
}
