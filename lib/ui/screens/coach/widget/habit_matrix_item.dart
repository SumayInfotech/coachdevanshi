import 'package:flutter/material.dart';

import '../../../widgets/common_text.dart';

class HabitMatrixOption {
  final String value;
  final String label;

  const HabitMatrixOption({required this.value, required this.label});
}

class HabitMatrixItem extends StatelessWidget {
  final String title;
  final String selectedValue;
  final ValueChanged<String> onChanged;
  final List<HabitMatrixOption>? options;

  const HabitMatrixItem({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.onChanged,
    this.options,
  });

  static const List<HabitMatrixOption> defaultOptions = [
    HabitMatrixOption(value: "manageable", label: "Manageable"),
    HabitMatrixOption(value: "could_reduce_with_support", label: "Could reduce with support"),
    HabitMatrixOption(value: "very_difficult", label: "Very difficult"),
    HabitMatrixOption(value: "not_relevant", label: "Not relevant"),
  ];

  @override
  Widget build(BuildContext context) {
    final opts = (options != null && options!.length >= 4) ? options! : defaultOptions;

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
              Expanded(child: _buildOptionBtn(opts[0])),
              const SizedBox(width: 8),
              Expanded(child: _buildOptionBtn(opts[1])),
            ],
          ),
        ),
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(child: _buildOptionBtn(opts[2])),
              const SizedBox(width: 8),
              Expanded(child: _buildOptionBtn(opts[3])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionBtn(HabitMatrixOption option) {
    final bool isSelected = selectedValue.trim().toLowerCase() == option.value.toLowerCase() ||
        selectedValue.trim().toLowerCase() == option.label.toLowerCase();

    return GestureDetector(
      onTap: () => onChanged(option.value),
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
          option.label,
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
