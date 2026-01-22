class LandModel {
  int? buildingCode;
  String? buildingNameA;
  String? buildingNameE;
  int? buildingStatus;
  int? parent;

  LandModel({
    this.buildingCode,
    this.buildingNameA,
    this.buildingNameE,
    this.buildingStatus,
    this.parent,
  });

  LandModel.fromJson(Map<String, dynamic> json) {
    buildingCode = json['building_code'];
    buildingNameA = json['building_name_a'];
    buildingNameE = json['building_name_e'];
    buildingStatus = json['building_status'];
    parent = json['parent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['building_code'] = buildingCode;
    data['building_name_a'] = buildingNameA;
    data['building_name_e'] = buildingNameE;
    data['building_status'] = buildingStatus;
    data['parent'] = parent;
    return data;
  }
}
