// lib/data/model/traking_response.dart

class TrakingResponse {
  final int orderId;
  final DateTime orderTime;
  final String zoneFrom;
  final String cityFrom;
  final String detailesAddressFrom;
  final String zoneTo;
  final String cityTo;
  final String detailesAddressTo;
  final int status;
  final int? deliveryId; // *** تم جعله nullable (int?) هنا ***

  TrakingResponse({
    required this.orderId,
    required this.orderTime,
    required this.zoneFrom,
    required this.cityFrom,
    required this.detailesAddressFrom,
    required this.zoneTo,
    required this.cityTo,
    required this.detailesAddressTo,
    required this.status,
    this.deliveryId, // *** ليس required إذا كان nullable ***
  });

  factory TrakingResponse.fromJson(Map<String, dynamic> json) {
    return TrakingResponse(
      orderId: json['order_id'] as int,
      orderTime: DateTime.parse(json['order_time'] as String),
      zoneFrom: json['zone_from'] as String,
      cityFrom: json['city_from'] as String,
      detailesAddressFrom: json['detailes_address_from'] as String,
      zoneTo: json['zone_to'] as String,
      cityTo: json['city_to'] as String,
      detailesAddressTo: json['detailes_address_to'] as String,
      status: json['status'] as int,
      deliveryId:
          json['delivery_id']
              as int?, // *** تم التعامل معها كـ nullable هنا ***
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_time': orderTime.toIso8601String(),
      'zone_from': zoneFrom,
      'city_from': cityFrom,
      'detailes_address_from': detailesAddressFrom,
      'zone_to': zoneTo,
      'city_to': cityTo,
      'detailes_address_to': detailesAddressTo,
      'status': status,
      'delivery_id': deliveryId,
    };
  }

  // **** أضف هذه الميثود copyWith ****
  TrakingResponse copyWith({
    int? orderId,
    DateTime? orderTime,
    String? zoneFrom,
    String? cityFrom,
    String? detailesAddressFrom,
    String? zoneTo,
    String? cityTo,
    String? detailesAddressTo,
    int? status,
    Object? deliveryId =
        const _Sentinel(), // For nullable fields, use _Sentinel for explicit null
  }) {
    return TrakingResponse(
      orderId: orderId ?? this.orderId,
      orderTime: orderTime ?? this.orderTime,
      zoneFrom: zoneFrom ?? this.zoneFrom,
      cityFrom: cityFrom ?? this.cityFrom,
      detailesAddressFrom: detailesAddressFrom ?? this.detailesAddressFrom,
      zoneTo: zoneTo ?? this.zoneTo,
      cityTo: cityTo ?? this.cityTo,
      detailesAddressTo: detailesAddressTo ?? this.detailesAddressTo,
      status: status ?? this.status,
      // Handle nullable deliveryId
      deliveryId:
          deliveryId is _Sentinel ? this.deliveryId : deliveryId as int?,
    );
  }

  // إضافة equals و hashCode لتحسين الأداء والمقارنة (موصى بها)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrakingResponse &&
        other.orderId == orderId &&
        other.orderTime == orderTime &&
        other.zoneFrom == zoneFrom &&
        other.cityFrom == cityFrom &&
        other.detailesAddressFrom == detailesAddressFrom &&
        other.zoneTo == zoneTo &&
        other.cityTo == cityTo &&
        other.detailesAddressTo == detailesAddressTo &&
        other.status == status &&
        other.deliveryId == deliveryId;
  }

  @override
  int get hashCode =>
      orderId.hashCode ^
      orderTime.hashCode ^
      zoneFrom.hashCode ^
      cityFrom.hashCode ^
      detailesAddressFrom.hashCode ^
      zoneTo.hashCode ^
      cityTo.hashCode ^
      detailesAddressTo.hashCode ^
      status.hashCode ^
      deliveryId.hashCode;
}

// Helper class for handling nullable fields in copyWith
class _Sentinel {
  const _Sentinel();
}
