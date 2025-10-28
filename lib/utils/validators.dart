// Utility validators used across the app for defensive input checking

bool isNotEmpty(String? value) {
  return value != null && value.trim().isNotEmpty;
}

int? tryParseInt(String value) {
  return int.tryParse(value);
}

bool isIntInRange(String value, int min, int max) {
  final v = tryParseInt(value);
  if (v == null) return false;
  return v >= min && v <= max;
}

bool looksLikeEmail(String? value) {
  if (value == null) return false;
  final v = value.trim();
  // Very small heuristic check: contains '@' and '.' after '@'
  final at = v.indexOf('@');
  if (at <= 0) return false;
  final dot = v.indexOf('.', at);
  return dot > at + 1 && dot < v.length - 1;
}

/// Returns true if [value] is a plausible http/https URL.
/// If [allowEmpty] is true (default), empty/null is considered valid (useful for optional fields).
bool looksLikeUrl(String? value, {bool allowEmpty = true}) {
  if (value == null || value.trim().isEmpty) return allowEmpty;
  final v = value.trim();
  final uri = Uri.tryParse(v);
  if (uri == null) return false;
  if (!uri.hasScheme) return false;
  final scheme = uri.scheme.toLowerCase();
  if (!(scheme == 'http' || scheme == 'https')) return false;
  return uri.host.isNotEmpty;
}
