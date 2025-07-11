import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueItems = items.toSet().toList();
    final filteredValue = uniqueItems.contains(value) ? value : null;

    return DropdownButtonFormField<String>(
      value: filteredValue,
      hint: Text(
        hint,
        style: const TextStyle(color: Colors.white), // لون الـ hint
      ),
      style: const TextStyle(color: Colors.white), // لون النص المختار
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white, // لون أيقونة السهم
      ),
      dropdownColor: Colors.grey[900], // لون قائمة العناصر المنسدلة (اختياري)
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white), // لون البوردر
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white), // لون البوردر عند التركيز
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white), // لون البوردر الافتراضي
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: uniqueItems
          .map(
            (e) => DropdownMenuItem(
          value: e,
          child: Text(
            e,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }
}
