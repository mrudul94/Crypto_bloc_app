// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/features/home/model/crypto_in_loss.dart';
import 'package:cryptoapp/features/home/repos/fetch_api_funtions.dart';
import 'package:meta/meta.dart';

part 'loss_event.dart';
part 'loss_state.dart';

class LossBloc extends Bloc<LossEvent, LossState> {
  LossBloc() : super(LossInitial()) {
    on<LossingCryptoFetchEvent>(lossingCryptoFetchEvent);
  }

  
      

  FutureOr<void> lossingCryptoFetchEvent(LossingCryptoFetchEvent event, Emitter<LossState> emit) async
  {
    try {
      emit(LossInitial()); // Optional: Emit loading state if needed
      List<LossingCryptoModel> losscryptos = await getLosingCryptos();

      if (losscryptos.isNotEmpty) {
        emit(LossingCryptoFetchSuccessfullState(losscryptos: losscryptos));
      } else {
        emit(LossingCryptoFetchFailureState(errorMessage: "No data available"));
      }
    } catch (e) {
      emit(LossingCryptoFetchFailureState(errorMessage: e.toString()));
    }
  }
}
