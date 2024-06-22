export 'lib/foodlist.dart';
class Foodlist {
  final String name;
   double calories;
   double serving;
   double fat_total;
   double fat_saturated;
   double protein;
   double carbohydrates;

  Foodlist({
    required this.calories,
    required this.serving,
    required this.fat_total,
    required this.fat_saturated,
    required this.protein,
    required this.carbohydrates,
    required this.name,
  });

  factory Foodlist.fromJson(dynamic json) {
    return Foodlist(
      name: json['name'] as String,
      calories: json['calories'] as double,
      serving: json['serving_size_g'] as double,
      fat_total: json['fat_total_g'] as double,
      fat_saturated: json['fat_saturated_g'] as double,
      protein: json['protein_g'] as double,
      carbohydrates: json['carbohydrates_total_g'] as double,
    );
  }

  static List<Foodlist> foodFromsnapshot(List snap) {
    return snap.map((data) {
      return Foodlist.fromJson(data);
    }).toList();
  }
}
