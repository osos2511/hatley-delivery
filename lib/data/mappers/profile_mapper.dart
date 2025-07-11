// في ملف: lib/data/mapper/profile_mapper.dart

import '../../domain/entities/profile_entity.dart';
import '../model/profile_response.dart';

extension ProfileMapper on ProfileResponse {
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id ?? -1, // تأكد من توفير قيمة افتراضية إذا كان id مطلوبًا
      name: name,
      phone: phone,
      email: email,
      photo: photo,
      nationalId: nationalId,
      // لا تُستخدم governorate و zone هنا إذا كنت تستخدم governorateId و zoneId
      // إذا كانت لديك حقول governorate و zone قديمة في ProfileEntity من نوع String،
      // فيجب عليك إزالتها أو إعادة تسميتها لتجنب الالتباس.

      // تعيين المعرفات (IDs)
      governorateId: governorateID?.toInt(), // <--- تعيين ID المحافظة
      zoneId: zoneID?.toInt(),               // <--- تعيين ID المنطقة

      // تعيين الأسماء (Names) للعرض، إذا كنت تحتاجها في الـ Entity
      governorateName: governorateName,      // <--- تعيين اسم المحافظة
      zoneName: zoneName,                    // <--- تعيين اسم المنطقة
    );
  }
}