// lib/domain/entities/profile_entity.dart

import 'package:equatable/equatable.dart'; // It's good practice to extend Equatable

class ProfileEntity extends Equatable { // Consider extending Equatable for proper comparison
  final num? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? nationalId;

  // These two fields are now specifically for the IDs, matching the names in ProfileResponse
  final int? governorateId; // This will hold the Governorate ID
  final int? zoneId;        // This will hold the Zone ID

  // Add fields for names, if you want to store them in the entity for display
  final String? governorateName; // To display the governorate's name
  final String? zoneName;        // To display the zone's name

  final String? photo;

  const ProfileEntity({ // Use const constructor for better performance
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.nationalId,
    this.governorateId, // Optional, since it might be null initially
    this.zoneId,        // Optional, since it might be null initially
    this.governorateName, // Optional
    this.zoneName,        // Optional
    this.photo,
  });

  // Make sure your copyWith method correctly handles all fields
  ProfileEntity copyWith({
    num? id,
    String? name,
    String? email,
    String? phone,
    String? nationalId,
    int? governorateId,   // Now expects int? for ID
    int? zoneId,          // Now expects int? for ID
    String? governorateName, // New parameter for name
    String? zoneName,        // New parameter for name
    String? photo,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      governorateId: governorateId ?? this.governorateId, // Correct type
      zoneId: zoneId ?? this.zoneId,                     // Correct type
      governorateName: governorateName ?? this.governorateName, // New field
      zoneName: zoneName ?? this.zoneName,                      // New field
      photo: photo ?? this.photo,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    nationalId,
    governorateId,
    zoneId,
    governorateName,
    zoneName,
    photo,
  ];
}