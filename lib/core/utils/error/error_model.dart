class ErrorModel {
  final String message;
  final String? status;
  final Map<String, List<String>>? data;

  ErrorModel({required this.message, this.status, this.data});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>>? validationErrors;

    if (json['data'] != null) {
      validationErrors = {};
      (json['data'] as Map<String, dynamic>).forEach((key, value) {
        if (value is List) {
          validationErrors![key] = List<String>.from(value);
        }
      });
    }

    return ErrorModel(
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      data: validationErrors,
    );
  }

  String? getFirstError() {
    if (data != null && data!.isNotEmpty) {
      final firstField = data!.keys.first;
      final errors = data![firstField];
      if (errors != null && errors.isNotEmpty) {
        return errors.first;
      }
    }
    return message;
  }
}
