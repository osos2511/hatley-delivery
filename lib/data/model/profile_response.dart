class ProfileResponse {
  ProfileResponse({
      this.id, 
      this.name, 
      this.phone, 
      this.email, 
      this.password, 
      this.nationalId, 
      this.photo, 
      this.frontNationalIDImg, 
      this.backNationalIDImg, 
      this.faceWithNationalIDImg, 
      this.governorateID, 
      this.zoneID, 
      this.governorateName, 
      this.zoneName,});

  ProfileResponse.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    nationalId = json['national_id'];
    photo = json['photo'];
    frontNationalIDImg = json['front_National_ID_img'];
    backNationalIDImg = json['back_National_ID_img'];
    faceWithNationalIDImg = json['face_with_National_ID_img'];
    governorateID = json['governorate_ID'];
    zoneID = json['zone_ID'];
    governorateName = json['governorate_Name'];
    zoneName = json['zone_Name'];
  }
  num? id;
  String? name;
  String? phone;
  String? email;
  String? password;
  String? nationalId;
  String? photo;
  String? frontNationalIDImg;
  String? backNationalIDImg;
  String? faceWithNationalIDImg;
  num? governorateID;
  num? zoneID;
  String? governorateName;
  String? zoneName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['email'] = email;
    map['password'] = password;
    map['national_id'] = nationalId;
    map['photo'] = photo;
    map['front_National_ID_img'] = frontNationalIDImg;
    map['back_National_ID_img'] = backNationalIDImg;
    map['face_with_National_ID_img'] = faceWithNationalIDImg;
    map['governorate_ID'] = governorateID;
    map['zone_ID'] = zoneID;
    map['governorate_Name'] = governorateName;
    map['zone_Name'] = zoneName;
    return map;
  }

}