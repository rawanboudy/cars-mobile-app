import 'package:hive/hive.dart';

part 'sell_request.g.dart';

@HiveType(typeId: 0)
class SellRequest extends HiveObject {
  @HiveField(0)
  final String brand;

  @HiveField(1)
  final String model;

  @HiveField(2)
  final String year;

  @HiveField(3)
  final String condition;

  @HiveField(4)
  final String fuelType;

  @HiveField(5)
  final String transmission;

  @HiveField(6)
  final String price;

  @HiveField(7)
  final String mileage;

  @HiveField(8)
  final String description;

  SellRequest({
    required this.brand,
    required this.model,
    required this.year,
    required this.condition,
    required this.fuelType,
    required this.transmission,
    required this.price,
    required this.mileage,
    required this.description,
  });
}
