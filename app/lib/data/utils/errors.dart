//! offline
class NoInternetConnectionException<T> implements Exception {
  final String message;
  final T? originalRequest;

  NoInternetConnectionException(
      {this.message = 'No Internet Connection', this.originalRequest});
}

//!  status : 0
class ServerException<T> implements Exception {
  final String message;
  final T? originalRequest;
  ServerException({this.message = 'Server Error', this.originalRequest});
}

//! general exception
class UnknownException<T> implements Exception {
  final String message;
  final T? originalRequest;

  UnknownException({this.message = 'An Error Occured', this.originalRequest});
}

//!  app version is invalid
class ForceUpdate implements Exception {
  final String message;

  ForceUpdate({this.message = 'Force Update'});
}

//! app is under maintaince or check app version failed
class AppUnderMaintenance implements Exception {
  final String message;

  AppUnderMaintenance({this.message = 'Maintaenance Mode'});
}

//! refresh token is invalid
class SessionExpiredException implements Exception {
  final String message;

  SessionExpiredException({this.message = 'Session Expired'});
}

//! can not parse response
class ParsingException implements Exception {
  final String? message;
  final String? stack;

  ParsingException({this.message = 'can not parse response', this.stack});
}
