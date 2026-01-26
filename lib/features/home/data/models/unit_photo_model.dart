class UnitPhotoModel {
  num? buildingCode;
  String? unitCode;
  String? pk1;
  String? model;
  String? unitName;
  num? docSerial;
  String? fileDesc;
  String? photoUrl;

  UnitPhotoModel({
    this.buildingCode,
    this.unitCode,
    this.pk1,
    this.model,
    this.unitName,
    this.docSerial,
    this.fileDesc,
    this.photoUrl,
  });

  UnitPhotoModel.fromJson(Map<String, dynamic> json) {
    buildingCode = json['building_code'];
    unitCode = json['unit_code'];
    pk1 = json['pk1'];
    model = json['model'];
    unitName = json['unit_name'];
    docSerial = json['doc_serial'];
    fileDesc = json['file_desc'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['building_code'] = buildingCode;
    data['unit_code'] = unitCode;
    data['pk1'] = pk1;
    data['model'] = model;
    data['unit_name'] = unitName;
    data['doc_serial'] = docSerial;
    data['file_desc'] = fileDesc;
    data['photo_url'] = photoUrl;
    return data;
  }
}
