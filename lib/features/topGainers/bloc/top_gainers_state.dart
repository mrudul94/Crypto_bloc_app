part of 'top_gainers_bloc.dart';

@immutable
sealed class TopGainersState {}

abstract class GainingStateAction extends TopGainersState {}

final class TopGainersInitial extends TopGainersState {}

class TopGainingCryptoFetchSuccessfullState extends TopGainersState {
  final List<TopGainCryptoModel> topcryptos;

  TopGainingCryptoFetchSuccessfullState({required this.topcryptos});

  
}

class TopGainingCryptoFetchFailureState extends TopGainersState {
  final String errorMessage;

  TopGainingCryptoFetchFailureState({required this.errorMessage});

  
}
