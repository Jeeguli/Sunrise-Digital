import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySummaryWidget extends StatelessWidget {
  final int businessCount;
  final int personalCount;
  final int completedCount;

  const CategorySummaryWidget({
    super.key,
    required this.businessCount,
    required this.personalCount,
    required this.completedCount,
  });

  String _taskLabel(int count) {
    if (count == 0) return "0 Task";
    if (count == 1) return "1 Task";
    return "$count Tasks";
  }

  Widget _buildCategoryBox({
    required String title,
    required int count,
    required Color bgColor,
    required BuildContext context,
  }) {
    final width = MediaQuery.of(context).size.width;

    final titleFontSize = width * 0.025;
    final countFontSize = width * 0.020;
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,

      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF252525),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _taskLabel(count),
            style: GoogleFonts.poppins(
              fontSize: countFontSize,
              color: Color(0xFF574512),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        "title": "Business",
        "count": businessCount,
        "color": const Color(0xFFFFF4E0),
      },
      {
        "title": "Personal",
        "count": personalCount,
        "color": const Color(0xFFE0F7FF),
      },
      {
        "title": "Completed",
        "count": completedCount,
        "color": const Color(0xFFE7FFE0),
      },
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.13,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryBox(
            title: category["title"] as String,
            count: category["count"] as int,
            bgColor: category["color"] as Color,
            context: context,
          );
        },
      ),
    );
  }
}
