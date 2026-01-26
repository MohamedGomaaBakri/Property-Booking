class CustomerModel {
  int? code;
  String? nameA;
  String? nameE;

  CustomerModel({this.code, this.nameA, this.nameE});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    nameA = json['name_a'];
    nameE = json['name_e'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name_a'] = nameA;
    data['name_e'] = nameE;
    return data;
  }
}
