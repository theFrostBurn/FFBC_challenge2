import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';

class FancyTitle extends StatelessWidget {
  const FancyTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.1),
            Colors.transparent,
            AppTheme.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cookie_outlined,
            color: AppTheme.accentColor,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            '제과점',
            style: GoogleFonts.notoSansKr(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.cookie_outlined,
            color: AppTheme.accentColor,
            size: 24,
          ),
        ],
      ),
    );
  }
}
