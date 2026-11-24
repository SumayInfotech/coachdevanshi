import 'package:flutter/material.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class NoteFromCoachCard extends StatefulWidget {
  final String note;
  final VoidCallback? onTap;

  const NoteFromCoachCard({
    super.key,
    this.note = "“XYZ, your digestive observations from Thursday reflect good gut ease with cooked warm lentils. Keep adhering to the 30-minute window for your morning water cadence before tea. Looking forward to our 1:1 check-in this Wednesday at 4:30 PM.”",
    this.onTap,
  });

  @override
  State<NoteFromCoachCard> createState() => _NoteFromCoachCardState();
}

class _NoteFromCoachCardState extends State<NoteFromCoachCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const TextStyle noteTextStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: Color(0xFF1D1B1A),
      height: 1.5,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1E6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonText(
            "Note from coach",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1B1A),
            ),
            fontFamily: fontFamilyPlusJakartaSans,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textSpan = TextSpan(
                    text: widget.note,
                    style: noteTextStyle,
                  );

                  final textPainter = TextPainter(
                    text: textSpan,
                    textDirection: TextDirection.ltr,
                    maxLines: 4,
                  )..layout(maxWidth: constraints.maxWidth);

                  final bool hasOverflow = textPainter.didExceedMaxLines;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        widget.note,
                        maxLines: _isExpanded ? null : 4,
                        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                        style: noteTextStyle,
                        fontFamily: fontFamilyPlusJakartaSans,
                      ),
                      if (hasOverflow) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: CommonText(
                            _isExpanded ? "show less" : "show more",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: appColors.primary,
                            ),
                            fontFamily: fontFamilyPlusJakartaSans,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
