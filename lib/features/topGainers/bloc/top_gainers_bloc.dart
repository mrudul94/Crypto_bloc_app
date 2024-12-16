// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/features/home/model/top_gain_model.dart';
import 'package:cryptoapp/features/home/repos/fetch_api_funtions.dart';
import 'package:meta/meta.dart';

part 'top_gainers_event.dart';
part 'top_gainers_state.dart';

class TopGainersBloc extends Bloc<TopGainersEvent, TopGainersState> {
  TopGainersBloc() : super(TopGainersInitial()) {
    on<TopGainingFetchEvent>(topGainingFetchEvent);
  }

  FutureOr<void> topGainingFetchEvent(TopGainingFetchEvent event, Emitter<TopGainersState> emit) async{
    try {
      emit(TopGainersInitial()); // Optional: Emit loading state if needed
      List<TopGainCryptoModel> topcryptos = await getTopGainers();

      if (topcryptos.isNotEmpty) {
        emit(TopGainingCryptoFetchSuccessfullState(topcryptos: topcryptos));
      } else {
        emit(TopGainingCryptoFetchFailureState(errorMessage: "No data available"));
      }
    } catch (e) {
      emit(TopGainingCryptoFetchFailureState(errorMessage: e.toString()));
    }
  }
}
