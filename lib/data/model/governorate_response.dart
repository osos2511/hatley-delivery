import '../../domain/entities/governorate_entity.dart';

class GovernorateResponse {
  num? governorateID;
  String? name;
  GovernorateResponse({
      this.governorateID, 
      this.name,});


  GovernorateResponse.fromJson(dynamic json) {
    governorateID = json['governorate_ID'];
    name = json['name'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['governorate_ID'] = governorateID;
    map['name'] = name;
    return map;
  }

  GovernorateEntity toEntity(){
    return GovernorateEntity(id: governorateID?.toInt() ?? 0, name: name??'');
  }

}