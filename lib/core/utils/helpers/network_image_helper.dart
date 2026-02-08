bool isSafeNetworkImageUrl(String? value) {
  if (value == null) return false;
  final trimmed = value.trim();
  if (trimmed.isEmpty) return false;
  final lower = trimmed.toLowerCase();
  if (!(lower.startsWith('http://') || lower.startsWith('https://'))) {
    return false;
  }
  if (lower.contains('via.placeholder.com')) {
    return false;
  }
  return true;
}

String? safeNetworkImageUrl(String? value) {
  if (!isSafeNetworkImageUrl(value)) return null;
  return value!.trim();
}
