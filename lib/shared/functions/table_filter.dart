List<Map<String, dynamic>> filterItems(
  List<Map<String, dynamic>> items,
  String query,
  List<String> searchFields,
) {
  if (query.isEmpty) return items;

  final searchLower = query.toLowerCase();
  return items.where((item) {
    return searchFields.any((field) {
      final value = item[field].toString().toLowerCase();
      return value.contains(searchLower);
    });
  }).toList();
}
