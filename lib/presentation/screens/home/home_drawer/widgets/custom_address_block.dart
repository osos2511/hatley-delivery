import 'package:flutter/material.dart';

class CustomAddressBlock extends StatelessWidget {
  final List<String> values;
  final bool isArabic;

  const CustomAddressBlock({
    super.key,
    required this.values,
    this.isArabic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: values.map((value) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            readOnly: true,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              hintText: value,
            ),
          ),
        );
      }).toList(),
    );
  }
}
