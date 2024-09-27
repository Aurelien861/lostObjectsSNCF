class LostObject {
  final String date;
  final String? startStation;
  final String? type;
  final String? nature;

  LostObject({
    required this.date,
    required this.nature,
    required this.type,
    required this.startStation,
  });

  factory LostObject.fromJson(Map<String, dynamic> json) {
    return LostObject(
      date: json['date'],
      startStation: json['gc_obo_gare_origine_r_name'],
      type: json['gc_obo_type_c'],
      nature: json['gc_obo_nature_c'],
    );
  }
}
