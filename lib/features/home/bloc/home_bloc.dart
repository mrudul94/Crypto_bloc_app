import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cryptoapp/features/home/model/crypto_model.dart';
import 'package:cryptoapp/features/home/repos/fetch_api_funtions.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

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
    List<CryptoModel> cryptos = await fetchCryptoData();

    if (cryptos.isNotEmpty) {
      emit(CryptoFetchSuccessfullState(cryptos: cryptos));
    } else {
      emit(CryptoFetchFailureState(errorMessage: "Failed to load crypto data"));
    }
  }

 

   
}
