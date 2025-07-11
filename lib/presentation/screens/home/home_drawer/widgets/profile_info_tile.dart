import 'package:flutter/material.dart';
import '../../../../../core/colors_manager.dart';

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_getIconForLabel(label), color: ColorsManager.white),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'username':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'national_id':
        return Icons.badge;
      case 'governorate_name':
        return Icons.location_city;
    case 'zone_name':
      return Icons.map;
      default:
        return Icons.info;
    }
  }
}
