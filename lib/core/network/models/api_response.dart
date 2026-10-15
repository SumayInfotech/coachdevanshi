class ApiResponse<T> {
  final bool status;
  final String message;
  final T? data;

  ApiResponse({required this.status, required this.message, this.data});

  factory ApiResponse.success({required T data, String message = "Success"}) {
    return ApiResponse(status: true, message: message, data: data);
  }

  factory ApiResponse.failure({required String message}) {
    return ApiResponse(status: false, message: message);
  }
}
