import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String text;
  final String iconPath;
  final ValueChanged<String?> onChanged;

  const PaymentOption({
    super.key,
    required this.value,
    required this.groupValue,
    required this.text,
    required this.iconPath,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0XFF476C2F).withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? const Color(0XFF476C2F)
                : const Color(0XFF456B2E).withOpacity(0.53),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset(iconPath, height: 30, width: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0XFF3F6B22),
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0XFF476C2F),
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
