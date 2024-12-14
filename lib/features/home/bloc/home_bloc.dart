import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cryptoapp/features/home/model/crypto_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomepageInitialFetchEvent>(homepageInitialFetchEvent);
  }

  FutureOr<void> homepageInitialFetchEvent(
    HomepageInitialFetchEvent event,
    Emitter<HomeState> emit,
  ) async {
    var client = http.Client();
    List<CryptoModel> cryptos = [];
    try {
      var response = await client.get(
        Uri.https('api.coingecko.com', '/api/v3/coins/markets', {'vs_currency': 'usd'}),
      );

      if (response.statusCode == 200) {
        List result = jsonDecode(response.body);
        for (var item in result) {
          CryptoModel crypto = CryptoModel.fromJson(item);
          cryptos.add(crypto);
        }
        
        emit(CryptoFetchSuccessfullState(cryptos: cryptos));
      } else {
        log('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: ${e.toString()}');
    } finally {
      client.close();
    }
  }
}

