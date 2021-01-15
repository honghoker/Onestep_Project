class CategoryException implements Exception {
  String cause;
  CategoryException(this.cause) {
    print(cause);
  }
}
