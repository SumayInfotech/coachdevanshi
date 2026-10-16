import 'package:flutter/material.dart';
import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class PathwayCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final bool isSelected;
  final List<String> tags;
  final VoidCallback onTap;

  const PathwayCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.tags,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: appColors.primary, width: 2) : null,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: appColors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2EDEB),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(icon, color: appColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CommonText(
                          title,
                          fontFamily: fontPlayfairDisplay,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1D1B1A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? appColors.primary : const Color(0xFFE7E1DF),
                  ),
                  child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            CommonText(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF534343),
                height: 21.13 / 13,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2EDEB),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: CommonText(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF534343),
                    letterSpacing: 0.33,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
