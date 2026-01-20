class FontManager {
  // Font Families
  static const String ibmPlexSans = 'IBMPlexSans';
  static const String ibmPlexSansCondensed = 'IBMPlexSans_Condensed';
  static const String ibmPlexSansSemiCondensed = 'IBMPlexSans_SemiCondensed';

  // Font Weights
  static const String thin = 'Thin';
  static const String extraLight = 'ExtraLight';
  static const String light = 'Light';
  static const String regular = 'Regular';
  static const String medium = 'Medium';
  static const String semiBold = 'SemiBold';
  static const String bold = 'Bold';

  // Helper methods to get font family with weight
  static String getFontFamily(String family, {String? weight}) {
    if (weight == null) return family;
    return '$family-$weight';
  }

  // Predefined font combinations
  static String get ibmPlexSansRegular => ibmPlexSans;
  static String get ibmPlexSansBold => '$ibmPlexSans-$bold';
  static String get ibmPlexSansMedium => '$ibmPlexSans-$medium';
  static String get ibmPlexSansLight => '$ibmPlexSans-$light';
  static String get ibmPlexSansThin => '$ibmPlexSans-$thin';

  static String get ibmPlexSansCondensedRegular => ibmPlexSansCondensed;
  static String get ibmPlexSansCondensedBold => '$ibmPlexSansCondensed-$bold';
  static String get ibmPlexSansCondensedMedium =>
      '$ibmPlexSansCondensed-$medium';

  static String get ibmPlexSansSemiCondensedRegular => ibmPlexSansSemiCondensed;
  static String get ibmPlexSansSemiCondensedBold =>
      '$ibmPlexSansSemiCondensed-$bold';
  static String get ibmPlexSansSemiCondensedMedium =>
      '$ibmPlexSansSemiCondensed-$medium';
}
