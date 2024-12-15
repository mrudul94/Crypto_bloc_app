// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/features/home/model/popular_crypto_model.dart';
import 'package:cryptoapp/features/home/repos/fetch_api_funtions.dart';
import 'package:meta/meta.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  PopularBloc() : super(PopularInitial()) {
    on<PopularCryptoFetchEvent>(_onPopularCryptoFetchEvent);
  }

  Future<void> _onPopularCryptoFetchEvent(
      PopularCryptoFetchEvent event, Emitter<PopularState> emit) async {
    try {
      emit(PopularInitial()); // Optional: Emit loading state if needed
      List<PopularCryptoModel> popularCrypto = await fetchPopulatCryptoData();

      if (popularCrypto.isNotEmpty) {
        emit(PopularCryptoFetchSuccessfullState(popularcryptos: popularCrypto));
      } else {
        emit(PopularCryptoFetchFailureState(errorMessage: "No data available"));
      }
    } catch (e) {
      emit(PopularCryptoFetchFailureState(errorMessage: e.toString()));
    }
  }
}

