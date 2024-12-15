part of 'popular_bloc.dart';

@immutable
sealed class PopularEvent {}
class PopularCryptoFetchEvent extends PopularEvent{}