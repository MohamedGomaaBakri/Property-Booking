class ApiResponseModel<T> {
  final bool status;
  final T? data;
  final String? message;

  ApiResponseModel({required this.status, this.data, this.message});

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponseModel<T>(
      status: json['status'] == true,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
    );
  }
}
