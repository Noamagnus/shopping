/// implements means we're signing a contract with Exception class
/// it means we're forced to implement all functions Exception class have

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
// return super.toString();
  }
}
