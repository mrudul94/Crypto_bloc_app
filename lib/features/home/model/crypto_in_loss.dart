import 'dart:convert';

class LossingCryptoModel {
  String id;
  String symbol;
  String name;
  String image;
  double currentPrice;
  double priceChange24H;
  double priceChangePercentage24H;
  DateTime lastUpdated;

  LossingCryptoModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChange24H,
    required this.priceChangePercentage24H,
    required this.lastUpdated,
  });

  factory LossingCryptoModel.fromRawJson(String str) =>
      LossingCryptoModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LossingCryptoModel.fromJson(Map<String, dynamic> json) =>
      LossingCryptoModel(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        currentPrice: json["current_price"]?.toDouble() ?? 0.0,
        priceChange24H: json["price_change_24h"]?.toDouble() ?? 0.0,
        priceChangePercentage24H:
            json["price_change_percentage_24h"]?.toDouble() ?? 0.0,
        lastUpdated: DateTime.parse(json["last_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "current_price": currentPrice,
        "price_change_24h": priceChange24H,
        "price_change_percentage_24h": priceChangePercentage24H,
        "last_updated": lastUpdated.toIso8601String(),
      };
}
