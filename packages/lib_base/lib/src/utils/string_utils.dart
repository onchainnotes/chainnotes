
class StringUtils {

  static bool isEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }

  static bool isNotEmpty(String? str) {
    return !isEmpty(str);
  }

  static String format(String template, List<dynamic> args) {
    String result = template;
    for (int i = 0; i < args.length; i++) {
      result = result.replaceAll('{$i}', args[i].toString());
    }
    return result;
  }

  static String truncate(String str, int maxLength, {String suffix = '...'}) {
    if (str.length <= maxLength) {
      return str;
    }
    return '${str.substring(0, maxLength)}$suffix';
  }

  static String capitalize(String str) {
    if (isEmpty(str)) return str;
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }
}
