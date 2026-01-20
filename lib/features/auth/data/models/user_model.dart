class UserModel {
  List<Items>? items;
  bool? hasMore;
  int? limit;
  int? offset;
  int? count;
  List<Links>? links;

  UserModel({
    this.items,
    this.hasMore,
    this.limit,
    this.offset,
    this.count,
    this.links,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    hasMore = json['hasMore'];
    limit = json['limit'];
    offset = json['offset'];
    count = json['count'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['hasMore'] = this.hasMore;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    data['count'] = this.count;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? usersCode;
  String? password;
  Null? empCode;
  int? roleCode;
  String? roleNameA;
  Null? roleNameE;
  Null? compEmpCode;
  String? empName;
  Null? empNameE;
  Null? ntnltyCode;
  Null? qlfyCtgryCode;
  Null? qlfyCode;
  Null? religionType;
  Null? birthDate;
  Null? birthPlc;
  Null? socialStatus;
  Null? currentAddress;
  Null? currentAddressE;
  Null? jobCode;
  Null? jobDesc;
  int? stopFlag;
  String? gender;

  Items({
    this.usersCode,
    this.password,
    this.empCode,
    this.roleCode,
    this.roleNameA,
    this.roleNameE,
    this.compEmpCode,
    this.empName,
    this.empNameE,
    this.ntnltyCode,
    this.qlfyCtgryCode,
    this.qlfyCode,
    this.religionType,
    this.birthDate,
    this.birthPlc,
    this.socialStatus,
    this.currentAddress,
    this.currentAddressE,
    this.jobCode,
    this.jobDesc,
    this.stopFlag,
    this.gender,
  });

  Items.fromJson(Map<String, dynamic> json) {
    usersCode = json['users_code'];
    password = json['password'];
    empCode = json['emp_code'];
    roleCode = json['role_code'];
    roleNameA = json['role_name_a'];
    roleNameE = json['role_name_e'];
    compEmpCode = json['comp_emp_code'];
    empName = json['emp_name'];
    empNameE = json['emp_name_e'];
    ntnltyCode = json['ntnlty_code'];
    qlfyCtgryCode = json['qlfy_ctgry_code'];
    qlfyCode = json['qlfy_code'];
    religionType = json['religion_type'];
    birthDate = json['birth_date'];
    birthPlc = json['birth_plc'];
    socialStatus = json['social_status'];
    currentAddress = json['current_address'];
    currentAddressE = json['current_address_e'];
    jobCode = json['job_code'];
    jobDesc = json['job_desc'];
    stopFlag = json['stop_flag'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['users_code'] = this.usersCode;
    data['password'] = this.password;
    data['emp_code'] = this.empCode;
    data['role_code'] = this.roleCode;
    data['role_name_a'] = this.roleNameA;
    data['role_name_e'] = this.roleNameE;
    data['comp_emp_code'] = this.compEmpCode;
    data['emp_name'] = this.empName;
    data['emp_name_e'] = this.empNameE;
    data['ntnlty_code'] = this.ntnltyCode;
    data['qlfy_ctgry_code'] = this.qlfyCtgryCode;
    data['qlfy_code'] = this.qlfyCode;
    data['religion_type'] = this.religionType;
    data['birth_date'] = this.birthDate;
    data['birth_plc'] = this.birthPlc;
    data['social_status'] = this.socialStatus;
    data['current_address'] = this.currentAddress;
    data['current_address_e'] = this.currentAddressE;
    data['job_code'] = this.jobCode;
    data['job_desc'] = this.jobDesc;
    data['stop_flag'] = this.stopFlag;
    data['gender'] = this.gender;
    return data;
  }
}

class Links {
  String? rel;
  String? href;

  Links({this.rel, this.href});

  Links.fromJson(Map<String, dynamic> json) {
    rel = json['rel'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rel'] = this.rel;
    data['href'] = this.href;
    return data;
  }
}
