const maxQrLength = 1000;

/// Outcome of checking user input: either the string to encode or an error.
class QrInput {
  const QrInput.ok(String this.data) : error = null;
  const QrInput.error(String this.error) : data = null;

  final String? data;
  final String? error;

  bool get isValid => error == null;
}

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
final _phoneChars = RegExp(r'^\+?[\d\s\-().]+$');

/// Validates [raw] for [type] (Text, URL, Email, Phone) and returns the
/// normalized payload: bare URLs get https://, emails get mailto:, phone
/// numbers get tel: so scanners open the right app.
QrInput validateQrInput(String type, String raw) {
  final text = raw.trim();
  if (text.isEmpty) return const QrInput.error('Enter something to encode');
  if (text.length > maxQrLength) {
    return const QrInput.error('Too long (max $maxQrLength characters)');
  }

  switch (type) {
    case 'URL':
      return _url(text);
    case 'Email':
      return _emailPattern.hasMatch(text)
          ? QrInput.ok('mailto:$text')
          : const QrInput.error('Enter a valid email address');
    case 'Phone':
      final digits = text.replaceAll(RegExp(r'\D'), '');
      final valid =
          _phoneChars.hasMatch(text) &&
          digits.length >= 7 &&
          digits.length <= 15;
      return valid
          ? QrInput.ok('tel:${text.startsWith('+') ? '+' : ''}$digits')
          : const QrInput.error('Enter a valid phone number (7-15 digits)');
    default:
      return QrInput.ok(text);
  }
}

QrInput _url(String text) {
  if (text.contains(RegExp(r'\s'))) {
    return const QrInput.error('URL cannot contain spaces');
  }
  final hasScheme = RegExp(r'^[a-zA-Z][a-zA-Z0-9+.\-]*://').hasMatch(text);
  final uri = Uri.tryParse(hasScheme ? text : 'https://$text');
  final host = uri?.host ?? '';
  final okScheme =
      uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  final okHost =
      host == 'localhost' || RegExp(r'^[^.]+(\.[^.]+)+$').hasMatch(host);
  if (!okScheme || !okHost) return const QrInput.error('Enter a valid URL');
  return QrInput.ok(uri.toString());
}
