import 'package:hive/hive.dart';

part 'watchlist_model.g.dart'; // Ensure this is present and correct

@HiveType(typeId: 0)
class WatchlistItem {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String symbol;

  @HiveField(2)
  final double currentPrice;

  @HiveField(3)
  final String imageUrl;
  WatchlistItem({
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.imageUrl
  });
}
