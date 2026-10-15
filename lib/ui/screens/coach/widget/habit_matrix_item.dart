import 'package:flutter/material.dart';

import '../../../widgets/common_text.dart';

class HabitMatrixItem extends StatelessWidget {
  final String title;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const HabitMatrixItem({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1B1A),
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(child: _buildOptionBtn("Manageable")),
              const SizedBox(width: 8),
              Expanded(child: _buildOptionBtn("Could reduce with support")),
            ],
          ),
        ),
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(child: _buildOptionBtn("Very difficult")),
              const SizedBox(width: 8),
              Expanded(child: _buildOptionBtn("Not relevant")),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionBtn(String value) {
    bool isSelected = selectedValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B484D) : const Color(0xFFF2EDEB),
          borderRadius: BorderRadius.circular(999),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 1)]
              : null,
        ),
        child: CommonText(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF534343),
            letterSpacing: 0.33,
          ),
        ),
      ),
    );
  }
}
