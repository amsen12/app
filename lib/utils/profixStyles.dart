import 'dart:ui';
import 'package:app/utils/profix_colors.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfixStyles {
  // Base Font Sizes (in pixels)
  static const double textXs = 12.0;
  static const double textSm = 14.0;
  static const double textBase = 16.0;
  static const double textLg = 18.0;
  static const double textXl = 20.0;
  static const double text2xl = 24.0;
  static const double text3xl = 30.0;
  static const double text4xl = 36.0;

  // Base Font Family
  static const String _fontFamily = 'Inter';

  // === BASE TYPOGRAPHY STYLES ===

  // Text XS (12px) - For timestamps, badges, chips, meta info
  static TextStyle textXsRegular = GoogleFonts.inter(
    fontSize: textXs,
    fontWeight: FontWeight.w400,
    color: ProfixColors.black,
  );
  static TextStyle textXsMedium = GoogleFonts.inter(
    fontSize: textXs,
    fontWeight: FontWeight.w500,
    color: ProfixColors.black,
  );
  static TextStyle textXsBold = GoogleFonts.inter(
    fontSize: textXs,
    fontWeight: FontWeight.w700,
    color: ProfixColors.black,
  );

  // Text SM (14px) - Default body text, labels, buttons, inputs
  static TextStyle textSmRegular = GoogleFonts.inter(
    fontSize: textSm,
    fontWeight: FontWeight.w400,
    color: ProfixColors.black,
  );
  static TextStyle textSmMedium = GoogleFonts.inter(
    fontSize: textSm,
    fontWeight: FontWeight.w500,
    color: ProfixColors.black,
  );
  static TextStyle textSmBold = GoogleFonts.inter(
    fontSize: textSm,
    fontWeight: FontWeight.w700,
    color: ProfixColors.black,
  );

  // Text BASE (16px) - Input fields specifically
  static TextStyle textBaseRegular = GoogleFonts.inter(
    fontSize: textBase,
    fontWeight: FontWeight.w400,
    color: ProfixColors.black,
  );
  static TextStyle textBaseMedium = GoogleFonts.inter(
    fontSize: textBase,
    fontWeight: FontWeight.w500,
    color: ProfixColors.black,
  );
  static TextStyle textBaseBold = GoogleFonts.inter(
    fontSize: textBase,
    fontWeight: FontWeight.w700,
    color: ProfixColors.black,
  );

  // Text LG (18px) - Section titles
  static TextStyle textLgRegular = GoogleFonts.inter(
    fontSize: textLg,
    fontWeight: FontWeight.w400,
    color: ProfixColors.black,
  );
  static TextStyle textLgMedium = GoogleFonts.inter(
    fontSize: textLg,
    fontWeight: FontWeight.w500,
    color: ProfixColors.black,
  );
  static TextStyle textLgBold = GoogleFonts.inter(
    fontSize: textLg,
    fontWeight: FontWeight.w700,
    color: ProfixColors.black,
  );

  // Text XL (20px) - Page headers, KPI numbers, stats
  static TextStyle textXlRegular = GoogleFonts.inter(
    fontSize: textXl,
    fontWeight: FontWeight.w400,
    color: ProfixColors.black,
  );
  static TextStyle textXlMedium = GoogleFonts.inter(
    fontSize: textXl,
    fontWeight: FontWeight.w500,
    color: ProfixColors.black,
  );
  static TextStyle textXlBold = GoogleFonts.inter(
    fontSize: textXl,
    fontWeight: FontWeight.w700,
    color: ProfixColors.black,
  );

  // Text 2XL (24px) - KPI numbers, stats, important prices/emphasis
  static TextStyle text2xlRegular = GoogleFonts.inter(
    fontSize: text2xl,
    fontWeight: FontWeight.w400,
    color: ProfixColors.black,
  );
  static TextStyle text2xlMedium = GoogleFonts.inter(
    fontSize: text2xl,
    fontWeight: FontWeight.w500,
    color: ProfixColors.black,
  );
  static TextStyle text2xlBold = GoogleFonts.inter(
    fontSize: text2xl,
    fontWeight: FontWeight.w700,
    color: ProfixColors.black,
  );

  // Text 3XL (30px) - Important prices/emphasis, brand/splash titles/main steps
  static TextStyle text3xlRegular = GoogleFonts.inter(
    fontSize: text3xl,
    fontWeight: FontWeight.w400,
    color: ProfixColors.black,
  );
  static TextStyle text3xlMedium = GoogleFonts.inter(
    fontSize: text3xl,
    fontWeight: FontWeight.w500,
    color: ProfixColors.black,
  );
  static TextStyle text3xlBold = GoogleFonts.inter(
    fontSize: text3xl,
    fontWeight: FontWeight.w700,
    color: ProfixColors.black,
  );

  // Text 4XL (36px) - Critical large numbers (countdown, 404, etc.)
  static TextStyle text4xlRegular = GoogleFonts.inter(
    fontSize: text4xl,
    fontWeight: FontWeight.w400,
    color: ProfixColors.black,
  );
  static TextStyle text4xlMedium = GoogleFonts.inter(
    fontSize: text4xl,
    fontWeight: FontWeight.w500,
    color: ProfixColors.black,
  );
  static TextStyle text4xlBold = GoogleFonts.inter(
    fontSize: text4xl,
    fontWeight: FontWeight.w700,
    color: ProfixColors.black,
  );

  // === COLOR VARIATIONS ===

  // White text variations
  static TextStyle textXsWhite = textXsBold.copyWith(color: ProfixColors.white);
  static TextStyle textSmWhite = textSmBold.copyWith(color: ProfixColors.white);
  static TextStyle textBaseWhite = textBaseBold.copyWith(color: ProfixColors.white);
  static TextStyle textLgWhite = textLgBold.copyWith(color: ProfixColors.white);
  static TextStyle textXlWhite = textXlBold.copyWith(color: ProfixColors.white);
  static TextStyle text2xlWhite = text2xlBold.copyWith(color: ProfixColors.white);
  static TextStyle text3xlWhite = text3xlBold.copyWith(color: ProfixColors.white);
  static TextStyle text4xlWhite = text4xlBold.copyWith(color: ProfixColors.white);

  // Primary color variations
  static TextStyle textXsPrimary = textXsBold.copyWith(color: ProfixColors.primary);
  static TextStyle textSmPrimary = textSmBold.copyWith(color: ProfixColors.primary);
  static TextStyle textBasePrimary = textBaseBold.copyWith(color: ProfixColors.primary);
  static TextStyle textLgPrimary = textLgBold.copyWith(color: ProfixColors.primary);
  static TextStyle textXlPrimary = textXlBold.copyWith(color: ProfixColors.primary);
  static TextStyle text2xlPrimary = text2xlBold.copyWith(color: ProfixColors.primary);
  static TextStyle text3xlPrimary = text3xlBold.copyWith(color: ProfixColors.primary);
  static TextStyle text4xlPrimary = text4xlBold.copyWith(color: ProfixColors.primary);

  // Gray text variations
  static TextStyle textXsGray = textXsRegular.copyWith(color: ProfixColors.gray2);
  static TextStyle textSmGray = textSmRegular.copyWith(color: ProfixColors.gray2);
  static TextStyle textBaseGray = textBaseRegular.copyWith(color: ProfixColors.gray2);
  static TextStyle textLgGray = textLgRegular.copyWith(color: ProfixColors.gray2);
  static TextStyle textXlGray = textXlRegular.copyWith(color: ProfixColors.gray2);
  static TextStyle text2xlGray = text2xlRegular.copyWith(color: ProfixColors.gray2);
  static TextStyle text3xlGray = text3xlRegular.copyWith(color: ProfixColors.gray2);
  static TextStyle text4xlGray = text4xlRegular.copyWith(color: ProfixColors.gray2);

  // === LEGACY COMPATIBILITY ===
  // Keep some existing styles for backward compatibility
  // Map them to new system gradually

  static TextStyle semi20Black = textXlMedium.copyWith(color: ProfixColors.black);
  static TextStyle semi20primary = textXlMedium.copyWith(color: ProfixColors.lightBlue);
  static TextStyle bold20Primary = textXlBold.copyWith(color: ProfixColors.lightBlue);
  static TextStyle bold14Primary = textSmBold.copyWith(color: ProfixColors.lightBlue);
  static TextStyle bold14black = textSmBold.copyWith(color: ProfixColors.black);
  static TextStyle bold12Weight = textXsBold.copyWith(color: ProfixColors.white);
  static TextStyle bold24Weight = text2xlBold.copyWith(color: ProfixColors.white);
  static TextStyle bold20black = textXlBold.copyWith(color: ProfixColors.black);
  static TextStyle bold20blue = textXlBold.copyWith(color: ProfixColors.blue);
  static TextStyle bold24black = text2xlBold.copyWith(color: ProfixColors.black);
  static TextStyle regular14White = textSmWhite;
  static TextStyle regular20White = textXlWhite;
  static TextStyle regular36primary = text3xlRegular.copyWith(color: ProfixColors.lightBlue);
  static TextStyle medium14White = textSmWhite;
  static TextStyle medium14primary = textSmPrimary;
  static TextStyle medium16blue = textBaseMedium.copyWith(color: ProfixColors.blue);
  static TextStyle medium16black = textBaseMedium.copyWith(color: ProfixColors.black);
  static TextStyle medium16white = textBaseWhite;
  static TextStyle medium20white = textXlWhite;
  static TextStyle medium20primary = textXlPrimary;
  static TextStyle bold16blue = textBaseBold.copyWith(color: ProfixColors.lightBlue);
  static TextStyle bold16gray = textBaseBold.copyWith(color: ProfixColors.gray2);
  static TextStyle medium20blue = textXlMedium.copyWith(color: ProfixColors.blue);
  static TextStyle medium16gray = textBaseRegular.copyWith(color: ProfixColors.gray);
  static TextStyle regular14gray = textSmGray;
  static TextStyle medium18gray = textLgMedium.copyWith(color: ProfixColors.gray2);
  static TextStyle medium18black = textLgRegular;
  static TextStyle bold26black = GoogleFonts.inter(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: ProfixColors.black,
  );
  static TextStyle regular12gray = textXsGray;

  // === HELPER METHODS ===

  // Get text style by size and weight
  static TextStyle getTextStyle({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color color = ProfixColors.black,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  // Quick access methods for common combinations
  static TextStyle getBodyText({Color? color}) => textSmRegular.copyWith(color: color ?? ProfixColors.black);
  static TextStyle getInputText({Color? color}) => textBaseRegular.copyWith(color: color ?? ProfixColors.black);
  static TextStyle getSectionTitle({Color? color}) => textLgBold.copyWith(color: color ?? ProfixColors.black);
  static TextStyle getPageHeader({Color? color}) => textXlBold.copyWith(color: color ?? ProfixColors.black);
  static TextStyle getBrandTitle({Color? color}) => text3xlBold.copyWith(color: color ?? ProfixColors.black);
  static TextStyle getKpiNumber({Color? color}) => textXlBold.copyWith(color: color ?? ProfixColors.black);
  static TextStyle getLargePrice({Color? color}) => text3xlBold.copyWith(color: color ?? ProfixColors.black);
  static TextStyle getCriticalNumber({Color? color}) => text4xlBold.copyWith(color: color ?? ProfixColors.black);
  static TextStyle getSmallMeta({Color? color}) => textXsRegular.copyWith(color: color ?? ProfixColors.gray2);
}