class ContentCategoryException implements Exception {
  String cause;
  ContentCategoryException(this.cause) {
    print(cause);
  }
}
