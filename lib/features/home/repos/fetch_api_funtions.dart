import 'dart:convert';
import 'dart:developer';
import 'package:cryptoapp/features/home/model/crypto_in_loss.dart';
import 'package:cryptoapp/features/home/model/crypto_model.dart';
import 'package:cryptoapp/features/home/model/popular_crypto_model.dart';
import 'package:cryptoapp/features/home/model/top_gain_model.dart';
import 'package:http/http.dart' as http;

// In-memory cache for API responses
Map<String, dynamic> _cache = {};
DateTime? _lastFetchTime;

// Retry logic for HTTP requests with exponential backoff
Future<http.Response> retryRequest(Future<http.Response> Function() request, {int retries = 3}) async {
  for (int attempt = 0; attempt < retries; attempt++) {
    try {
      var response = await request();
      if (response.statusCode != 429) return response;
      log('Rate limit hit. Retrying after ${attempt + 1} seconds...');
      await Future.delayed(Duration(seconds: (attempt + 1) * 2)); // Exponential backoff
    } catch (e) {
      log('Error on attempt $attempt: ${e.toString()}');
    }
  }
  throw Exception('Failed after $retries attempts');
}

// Delay to throttle requests
Future<void> delayRequest() async {
  await Future.delayed(const Duration(milliseconds: 1200)); // 1.2 seconds delay
}

// Fetch Crypto Data
Future<List<CryptoModel>> fetchCryptoData() async {
  if (_cache.containsKey('crypto_data') &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < const Duration(minutes: 1)) {
    log('Serving data from cache');
    return _cache['crypto_data'];
  }

  var client = http.Client();
  var uri = Uri.https('api.coingecko.com', '/api/v3/coins/markets', {'vs_currency': 'usd'});

  try {
    await delayRequest(); // Add throttling
    var response = await retryRequest(() => client.get(uri));

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);
      var data = result.map((item) => CryptoModel.fromJson(item)).toList();
      _cache['crypto_data'] = data;
      _lastFetchTime = DateTime.now();
      return data;
    } else {
      log('Failed to fetch data: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    log('Error: ${e.toString()}');
    return [];
  } finally {
    client.close();
  }
}

// Fetch Popular Cryptos
Future<List<PopularCryptoModel>> fetchPopularCryptoData() async {
  var client = http.Client();
  var uri = Uri.https(
    'api.coingecko.com',
    '/api/v3/coins/markets',
    {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'per_page': '10',
      'page': '1',
    },
  );

  try {
    await delayRequest(); // Add throttling
    var response = await retryRequest(() => client.get(uri));

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);
      return result.map((item) => PopularCryptoModel.fromJson(item)).toList();
    } else {
      log('Failed to fetch data: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    log('Error: ${e.toString()}');
    return [];
  } finally {
    client.close();
  }
}

// Fetch Losing Cryptos
Future<List<LossingCryptoModel>> getLosingCryptos() async {
  var client = http.Client();
  var uri = Uri.https(
    'api.coingecko.com',
    '/api/v3/coins/markets',
    {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'per_page': '100',
      'page': '1',
    },
  );

  try {
    await delayRequest(); // Add throttling
    var response = await retryRequest(() => client.get(uri));

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);

      List<LossingCryptoModel> cryptos = result
          .map((item) => LossingCryptoModel.fromJson(item))
          .toList();

      cryptos.sort((a, b) => a.priceChangePercentage24H.compareTo(
            b.priceChangePercentage24H,
          ));

      return cryptos.take(10).toList(); // Return top 10 losers
    } else {
      log('Failed to fetch data: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    log('Error: ${e.toString()}');
    return [];
  } finally {
    client.close();
  }
}

// Fetch Top Gainers
Future<List<TopGainCryptoModel>> getTopGainers() async {
  if (_cache.containsKey('top_gainers') &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < const Duration(minutes: 1)) {
    log('Serving top gainers data from cache');
    return _cache['top_gainers'];
  }

  var client = http.Client();
  var uri = Uri.https(
    'api.coingecko.com',
    '/api/v3/coins/markets',
    {
      'vs_currency': 'usd',
      'order': 'percent_change_24h',
      'per_page': '10',
      'page': '1',
    },
  );

  try {
    await delayRequest(); // Add throttling
    var response = await retryRequest(() => client.get(uri));

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);

      List<TopGainCryptoModel> cryptos = result
          .map((item) => TopGainCryptoModel.fromJson(item))
          .toList();

      cryptos = cryptos.where((crypto) => crypto.priceChangePercentage24H > 0).toList();
      cryptos.sort((a, b) => b.priceChangePercentage24H.compareTo(a.priceChangePercentage24H));

      _cache['top_gainers'] = cryptos; // Cache the data
      _lastFetchTime = DateTime.now(); // Update fetch time
      return cryptos.take(10).toList(); // Return top 10 gainers
    } else {
      log('Failed to fetch top gainers: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    log('Error: ${e.toString()}');
    return [];
  } finally {
    client.close();
  }
}


// Add to Watchlist
Future<bool> addToWatchlist(String name, String symbol, double currentPrice, String imageUrl) async {
  var client = http.Client();
  var uri = Uri.https('reqres.in', '/api/users'); // Mock API endpoint

  try {
    var response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'symbol': symbol,
        'currentPrice': currentPrice,
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode == 201) {
      log('Successfully added to watchlist: ${response.body}');
      return true; // POST successful
    } else {
      log('Failed to add to watchlist: ${response.statusCode}');
      return false; // POST failed
    }
  } catch (e) {
    log('Error during POST request: ${e.toString()}');
    return false;
  } finally {
    client.close();
  }
}
