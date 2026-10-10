
class ValidationUtils {

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  static int getPasswordStrength(String password) {
    if (password.length < 6) return 0;

    bool hasLower = false;
    bool hasUpper = false;
    bool hasDigit = false;
    bool hasSpecial = false;

    for (var char in password.split('')) {
      if (char.contains(RegExp(r'[a-z]'))) hasLower = true;
      if (char.contains(RegExp(r'[A-Z]'))) hasUpper = true;
      if (char.contains(RegExp(r'[0-9]'))) hasDigit = true;
      if (char.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) hasSpecial = true;
    }

    int strength = 0;
    if (hasLower) strength++;
    if (hasUpper) strength++;
    if (hasDigit) strength++;
    if (hasSpecial) strength++;

    if (strength <= 2) return 0;
    if (strength == 3) return 1;
    return 2;
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}
