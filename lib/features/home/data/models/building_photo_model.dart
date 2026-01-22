class BuildingPhotoModel {
  int? buildingCode;
  int? modelCode;
  String? pk1;
  String? model;
  String? modelName;
  int? modelArea;
  int? docSerial;
  String? fileDesc;
  String? photoURL;

  BuildingPhotoModel({
    this.buildingCode,
    this.modelCode,
    this.pk1,
    this.model,
    this.modelName,
    this.modelArea,
    this.docSerial,
    this.fileDesc,
    this.photoURL,
  });

  BuildingPhotoModel.fromJson(Map<String, dynamic> json) {
    buildingCode = json['building_code'];
    modelCode = json['model_code'];
    pk1 = json['pk1'];
    model = json['model'];
    modelName = json['model_name'];
    modelArea = json['model_area'];
    docSerial = json['doc_serial'];
    fileDesc = json['file_desc'];
    photoURL = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['building_code'] = buildingCode;
    data['model_code'] = modelCode;
    data['pk1'] = pk1;
    data['model'] = model;
    data['model_name'] = modelName;
    data['model_area'] = modelArea;
    data['doc_serial'] = docSerial;
    data['file_desc'] = fileDesc;
    data['photo_url'] = photoURL;
    return data;
  }
}
