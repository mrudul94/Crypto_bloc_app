part of 'loss_bloc.dart';

@immutable
sealed class LossEvent {}
class LossingCryptoFetchEvent extends LossEvent{}