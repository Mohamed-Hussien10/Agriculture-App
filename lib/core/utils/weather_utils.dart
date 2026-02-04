class WeatherUtils {
  static String toEgyptian(String desc) {
    final d = desc.toLowerCase();
    if (d.contains('clear')) return 'سماء صافية';
    if (d.contains('cloud')) return 'غائم جزئياً';
    if (d.contains('rain')) return 'أمطار خفيفة';
    if (d.contains('storm')) return 'عواصف رعدية';
    if (d.contains('snow')) return 'ثلوج';
    if (d.contains('mist') || d.contains('fog')) return 'ضباب';
    return desc;
  }

  static String getTodayDate() {
    final now = DateTime.now();
    final arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${now.day} ${arabicMonths[now.month - 1]} ${now.year}';
  }
}