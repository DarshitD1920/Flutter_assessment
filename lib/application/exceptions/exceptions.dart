class ApiException implements Exception {
  final String message;

  ApiException({this.message = 'Unknown error occurred. '});
}
