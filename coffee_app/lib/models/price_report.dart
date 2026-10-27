import 'cafe.dart';
import 'user.dart';

class PriceReport {
  final int id;
  final String drinkType;
  final String milkType;
  final String size;
  final double price;
  final User user;
  final Cafe cafe;

  PriceReport({
    required this.id,
    required this.drinkType,
    required this.milkType,
    required this.size,
    required this.price,
    required this.user,
    required this.cafe,
  });

  factory PriceReport.fromJson(Map<String, dynamic> json) {
    return PriceReport(
      id: json['id'],
      drinkType: json['drink_type'],
      milkType: json['milk_type'],
      size: json['size'],
      price: double.parse(json['price']),
      user: User.fromJson(json['user']),
      cafe: Cafe.fromJson(json['cafe']),
    );
  }
}
