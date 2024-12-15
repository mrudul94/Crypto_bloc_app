part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class CryptoFetchSuccessfullState extends HomeState {
  final List<CryptoModel> cryptos;

  CryptoFetchSuccessfullState({required this.cryptos});
}

class CryptoFetchFailureState extends HomeState {
  final String errorMessage;

  CryptoFetchFailureState({required this.errorMessage});
}

