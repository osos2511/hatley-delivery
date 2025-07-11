import '../../domain/entities/zone_entity.dart';

class ZoneResponse {
  num? zoneId;
  String? name;
  num? north;
  num? east;
  num? governorateId;
  ZoneResponse({
      this.zoneId, 
      this.name, 
      this.north, 
      this.east, 
      this.governorateId,});

  ZoneResponse.fromJson(dynamic json) {
    zoneId = json['zone_id'];
    name = json['name'];
    north = json['north'];
    east = json['east'];
    governorateId = json['governorate_id'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zone_id'] = zoneId;
    map['name'] = name;
    map['north'] = north;
    map['east'] = east;
    map['governorate_id'] = governorateId;
    return map;
  }

  ZoneEntity toEntity(){
    return ZoneEntity(
        zoneId: zoneId?.toInt()??0,
        name: name??'',
        east: east?.toDouble()??0.0,
        governorateId: governorateId?.toInt()??0,
        north: north?.toDouble()??0.0);
  }

}