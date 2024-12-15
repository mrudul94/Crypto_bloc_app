import 'dart:convert';

class PopularCryptoModel {
  String id;
  String symbol;
  String name;
  String image;
  double currentPrice;
  int marketCap;
  int marketCapRank;
  int? fullyDilutedValuation; // Nullable field
  int totalVolume;
  double high24H;
  double low24H;
  double priceChange24H;
  double priceChangePercentage24H;
  double marketCapChange24H;
  double marketCapChangePercentage24H;
  double circulatingSupply;
  double? totalSupply; // Nullable field
  int? maxSupply; // Nullable field
  double ath;
  double athChangePercentage;
  DateTime athDate;
  double atl;
  double atlChangePercentage;
  DateTime atlDate;
  Roi? roi; // Nullable field
  DateTime lastUpdated;

  PopularCryptoModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    this.fullyDilutedValuation, // Nullable field
    required this.totalVolume,
    required this.high24H,
    required this.low24H,
    required this.priceChange24H,
    required this.priceChangePercentage24H,
    required this.marketCapChange24H,
    required this.marketCapChangePercentage24H,
    required this.circulatingSupply,
    this.totalSupply, // Nullable field
    this.maxSupply, // Nullable field
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    this.roi, // Nullable field
    required this.lastUpdated,
  });

  // Helper functions for type conversion and null handling
  static double _toDouble(dynamic value) => value != null ? (value as num).toDouble() : 0.0;
  static int? _toNullableInt(dynamic value) => value != null ? (value as num).toInt() : null;

  factory PopularCryptoModel.fromRawJson(String str) =>
      PopularCryptoModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PopularCryptoModel.fromJson(Map<String, dynamic> json) =>
      PopularCryptoModel(
        id: json["id"] as String,
        symbol: json["symbol"] as String,
        name: json["name"] as String,
        image: json["image"] as String,
        currentPrice: _toDouble(json["current_price"]),
        marketCap: (json["market_cap"] as num).toInt(),
        marketCapRank: json["market_cap_rank"] as int,
        fullyDilutedValuation: _toNullableInt(json["fully_diluted_valuation"]),
        totalVolume: (json["total_volume"] as num).toInt(),
        high24H: _toDouble(json["high_24h"]),
        low24H: _toDouble(json["low_24h"]),
        priceChange24H: _toDouble(json["price_change_24h"]),
        priceChangePercentage24H: _toDouble(json["price_change_percentage_24h"]),
        marketCapChange24H: _toDouble(json["market_cap_change_24h"]),
        marketCapChangePercentage24H: _toDouble(json["market_cap_change_percentage_24h"]),
        circulatingSupply: _toDouble(json["circulating_supply"]),
        totalSupply: json["total_supply"] != null
            ? (json["total_supply"] as num).toDouble()
            : null,
        maxSupply: _toNullableInt(json["max_supply"]),
        ath: _toDouble(json["ath"]),
        athChangePercentage: _toDouble(json["ath_change_percentage"]),
        athDate: DateTime.parse(json["ath_date"] as String),
        atl: _toDouble(json["atl"]),
        atlChangePercentage: _toDouble(json["atl_change_percentage"]),
        atlDate: DateTime.parse(json["atl_date"] as String),
        roi: json["roi"] != null ? Roi.fromJson(json["roi"]) : null,
        lastUpdated: DateTime.parse(json["last_updated"] as String),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "current_price": currentPrice,
        "market_cap": marketCap,
        "market_cap_rank": marketCapRank,
        "fully_diluted_valuation": fullyDilutedValuation,
        "total_volume": totalVolume,
        "high_24h": high24H,
        "low_24h": low24H,
        "price_change_24h": priceChange24H,
        "price_change_percentage_24h": priceChangePercentage24H,
        "market_cap_change_24h": marketCapChange24H,
        "market_cap_change_percentage_24h": marketCapChangePercentage24H,
        "circulating_supply": circulatingSupply,
        "total_supply": totalSupply,
        "max_supply": maxSupply,
        "ath": ath,
        "ath_change_percentage": athChangePercentage,
        "ath_date": athDate.toIso8601String(),
        "atl": atl,
        "atl_change_percentage": atlChangePercentage,
        "atl_date": atlDate.toIso8601String(),
        "roi": roi?.toJson(),
        "last_updated": lastUpdated.toIso8601String(),
      };
}

class Roi {
  double times;
  String currency;
  double percentage;

  Roi({
    required this.times,
    required this.currency,
    required this.percentage,
  });

  factory Roi.fromRawJson(String str) => Roi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Roi.fromJson(Map<String, dynamic> json) => Roi(
        times: (json["times"] as num).toDouble(),
        currency: json["currency"] as String,
        percentage: (json["percentage"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "times": times,
        "currency": currency,
        "percentage": percentage,
      };
}
