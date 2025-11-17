/// Utility for formatting large numbers in a readable way
class NumberFormatter {
  static String format(double number) {
    if (number < 1000) {
      return number.toStringAsFixed(0);
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number < 1000000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else {
      return '${(number / 1000000000000).toStringAsFixed(1)}T';
    }
  }

  /// Format with more precision for smaller numbers
  static String formatDetailed(double number) {
    if (number < 1000) {
      return number.toStringAsFixed(1);
    } else {
      return format(number);
    }
  }
}
