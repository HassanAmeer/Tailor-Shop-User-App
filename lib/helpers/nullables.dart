////////////////////
extension ToNullStringExtension on String? {
  String toNullString() {
    if (this == null ||
        this!.trim().isEmpty ||
        this!.trim().toLowerCase() == "null") {
      return "";
    }
    return this!;
  }
}

extension ToNullIntExtension on int? {
  int toNullInt() {
    final parsedInt = int.tryParse(toString());
    if (parsedInt == null || parsedInt <= 0) {
      return 0;
    }
    return int.parse(parsedInt.toString());
  }
}
