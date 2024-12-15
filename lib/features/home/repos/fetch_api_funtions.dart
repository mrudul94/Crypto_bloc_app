import 'dart:convert';
import 'dart:developer';

import 'package:cryptoapp/features/home/model/crypto_in_loss.dart';
import 'package:cryptoapp/features/home/model/crypto_model.dart';
import 'package:cryptoapp/features/home/model/popular_crypto_model.dart';
import 'package:cryptoapp/features/home/model/top_gain_model.dart';
import 'package:http/http.dart' as http;

Future<List<CryptoModel>> fetchCryptoData() async {
  var client = http.Client();
  try {
    var response = await client.get(
      Uri.https('api.coingecko.com', '/api/v3/coins/markets', {'vs_currency': 'usd'}),
    );

    if (response.statusCode == 200) {
      
      List result = jsonDecode(response.body);
      return result.map((item) => CryptoModel.fromJson(item)).toList();
      
    } 
    else {
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

Future<List<PopularCryptoModel>> fetchPopulatCryptoData() async {
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
  var response = await client.get(uri);


  if (response.statusCode == 200) {
    List result = jsonDecode(response.body);
    return result.map((item) => PopularCryptoModel.fromJson(item)).toList();
  } else {
    log('Failed to fetch datas: ${response.statusCode}');
    return [];
  }
} catch (e) {
  log('Error: ${e.toString()}');
  return [];
} finally {
  client.close();
}

}


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
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);

      // Parse and sort the cryptocurrencies by the largest percentage loss
      List<LossingCryptoModel> cryptos = result
          .map((item) => LossingCryptoModel.fromJson(item))
          .toList();

      cryptos.sort((a, b) => a.priceChangePercentage24H.compareTo(
            b.priceChangePercentage24H,
          ));

      return cryptos.take(10).toList(); // Return only the top 10 losers
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
Future<List<TopGainCryptoModel>> getTopGainers() async {
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
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);

      // Parse the cryptocurrencies
      List<TopGainCryptoModel> cryptos = result
          .map((item) => TopGainCryptoModel.fromJson(item))
          .toList();

      // Filter out coins that have a negative percentage change in the last 24 hours
      cryptos = cryptos.where((crypto) => crypto.priceChangePercentage24H > 0).toList();

      // Sort by percentage change in descending order for top gainers
      cryptos.sort((a, b) => b.priceChangePercentage24H.compareTo(a.priceChangePercentage24H));

      // Return the top 10 gainers
      return cryptos.take(10).toList();
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

