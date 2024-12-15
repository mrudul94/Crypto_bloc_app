part of 'popular_bloc.dart';

@immutable
sealed class PopularState {}

abstract class PopularActionState extends PopularState {}

final class PopularInitial extends PopularState {}

class PopularCryptoFetchSuccessfullState extends PopularState {
  final List<PopularCryptoModel> popularcryptos;

  PopularCryptoFetchSuccessfullState({required this.popularcryptos});
}

class PopularCryptoFetchFailureState extends PopularState {
  final String errorMessage;

  PopularCryptoFetchFailureState({required this.errorMessage});
}
