part of 'loss_bloc.dart';

@immutable
sealed class LossState {}

abstract class LossingActionState extends LossState {}

final class LossInitial extends LossState {}

class LossingCryptoFetchSuccessfullState extends LossState {
  final List<LossingCryptoModel> losscryptos;

  LossingCryptoFetchSuccessfullState({required this.losscryptos});
}

class LossingCryptoFetchFailureState extends LossState {
  final String errorMessage;

  LossingCryptoFetchFailureState({required this.errorMessage});
}
