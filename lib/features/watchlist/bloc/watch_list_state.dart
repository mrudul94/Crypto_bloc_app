part of 'watch_list_bloc.dart';

@immutable
sealed class WatchListState {}

final class WatchListInitial extends WatchListState {}

class WatchlistLoading extends WatchListState{}

class WatchlistLoaded extends WatchListState{
  final List<WatchlistItem> cryptos;

  WatchlistLoaded(this.cryptos);
}
class WatchListAdded extends WatchListState{
  final String message;

  WatchListAdded(this.message);
}

class WatchListError extends WatchListState{
  final String error;

  WatchListError(this.error);
}