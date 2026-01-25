class UnitModel {
  num? buildingCode;
  String? buildingNameA;
  String? unitCode;
  String? modelName;
  num? calcInstValUnit;
  num? totPrice;
  num? modelCode;
  num? levelNo;
  String? flatNo;
  num? unitStatus;
  num? reservedFlag;
  String? unitNameA;
  String? unitNameE;
  dynamic typeCode;
  dynamic activityCode;
  num? unitArea;
  dynamic actUnitArea;
  double? meterPriceInst;
  dynamic meterPriceCash;
  dynamic instMonths;
  dynamic instNo;
  dynamic accountNumber;
  dynamic costCode;
  dynamic costCode2;
  String? notes;
  num? deleteFlag;
  num? lateDdctPrc;
  num? discDdctPrc;
  dynamic landCode;
  num? deptNo;
  dynamic saleMany;
  dynamic saleFlag;
  dynamic faceCode;
  dynamic levelStart;
  dynamic rentPrice;
  dynamic instValUnitCol;
  num? unitSerial;
  dynamic electricalMeter;
  dynamic meterPrice;
  num? armyUnits;
  num? hold;
  num? compUnit;
  dynamic compCode;

  UnitModel({
    this.buildingCode,
    this.buildingNameA,
    this.unitCode,
    this.modelName,
    this.calcInstValUnit,
    this.totPrice,
    this.modelCode,
    this.levelNo,
    this.flatNo,
    this.unitStatus,
    this.reservedFlag,
    this.unitNameA,
    this.unitNameE,
    this.typeCode,
    this.activityCode,
    this.unitArea,
    this.actUnitArea,
    this.meterPriceInst,
    this.meterPriceCash,
    this.instMonths,
    this.instNo,
    this.accountNumber,
    this.costCode,
    this.costCode2,
    this.notes,
    this.deleteFlag,
    this.lateDdctPrc,
    this.discDdctPrc,
    this.landCode,
    this.deptNo,
    this.saleMany,
    this.saleFlag,
    this.faceCode,
    this.levelStart,
    this.rentPrice,
    this.instValUnitCol,
    this.unitSerial,
    this.electricalMeter,
    this.meterPrice,
    this.armyUnits,
    this.hold,
    this.compUnit,
    this.compCode,
  });

  UnitModel.fromJson(Map<String, dynamic> json) {
    buildingCode = json['building_code'];
    buildingNameA = json['building_name_a'];
    unitCode = json['unit_code'];
    modelName = json['model_name'];
    calcInstValUnit = json['calc_inst_val_unit'];
    totPrice = json['tot_price'];
    modelCode = json['model_code'];
    levelNo = json['level_no'];
    flatNo = json['flat_no'];
    unitStatus = json['unit_status'];
    reservedFlag = json['reserved_flag'];
    unitNameA = json['unit_name_a'];
    unitNameE = json['unit_name_e'];
    typeCode = json['type_code'];
    activityCode = json['activity_code'];
    unitArea = json['unit_area'];
    actUnitArea = json['act_unit_area'];
    meterPriceInst = json['meter_price_inst'];
    meterPriceCash = json['meter_price_cash'];
    instMonths = json['inst_months'];
    instNo = json['inst_no'];
    accountNumber = json['account_number'];
    costCode = json['cost_code'];
    costCode2 = json['cost_code2'];
    notes = json['notes'];
    deleteFlag = json['delete_flag'];
    lateDdctPrc = json['late_ddct_prc'];
    discDdctPrc = json['disc_ddct_prc'];
    landCode = json['land_code'];
    deptNo = json['dept_no'];
    saleMany = json['sale_many'];
    saleFlag = json['sale_flag'];
    faceCode = json['face_code'];
    levelStart = json['level_start'];
    rentPrice = json['rent_price'];
    instValUnitCol = json['inst_val_unit_col'];
    unitSerial = json['unit_serial'];
    electricalMeter = json['electrical_meter'];
    meterPrice = json['meter_price'];
    armyUnits = json['army_units'];
    hold = json['hold'];
    compUnit = json['comp_unit'];
    compCode = json['comp_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['building_code'] = buildingCode;
    data['building_name_a'] = buildingNameA;
    data['unit_code'] = unitCode;
    data['model_name'] = modelName;
    data['calc_inst_val_unit'] = calcInstValUnit;
    data['tot_price'] = totPrice;
    data['model_code'] = modelCode;
    data['level_no'] = levelNo;
    data['flat_no'] = flatNo;
    data['unit_status'] = unitStatus;
    data['reserved_flag'] = reservedFlag;
    data['unit_name_a'] = unitNameA;
    data['unit_name_e'] = unitNameE;
    data['type_code'] = typeCode;
    data['activity_code'] = activityCode;
    data['unit_area'] = unitArea;
    data['act_unit_area'] = actUnitArea;
    data['meter_price_inst'] = meterPriceInst;
    data['meter_price_cash'] = meterPriceCash;
    data['inst_months'] = instMonths;
    data['inst_no'] = instNo;
    data['account_number'] = accountNumber;
    data['cost_code'] = costCode;
    data['cost_code2'] = costCode2;
    data['notes'] = notes;
    data['delete_flag'] = deleteFlag;
    data['late_ddct_prc'] = lateDdctPrc;
    data['disc_ddct_prc'] = discDdctPrc;
    data['land_code'] = landCode;
    data['dept_no'] = deptNo;
    data['sale_many'] = saleMany;
    data['sale_flag'] = saleFlag;
    data['face_code'] = faceCode;
    data['level_start'] = levelStart;
    data['rent_price'] = rentPrice;
    data['inst_val_unit_col'] = instValUnitCol;
    data['unit_serial'] = unitSerial;
    data['electrical_meter'] = electricalMeter;
    data['meter_price'] = meterPrice;
    data['army_units'] = armyUnits;
    data['hold'] = hold;
    data['comp_unit'] = compUnit;
    data['comp_code'] = compCode;
    return data;
  }
}
