import 'package:flutter/material.dart';

@immutable
sealed class WatchListEvent {}

// ignore: must_be_immutable
class AddToWatchList extends WatchListEvent {
  String name;
  String symbol;
  double currentPrice;
  String imageUrl;
  final BuildContext context;

  AddToWatchList({required this.name, required this.symbol, required this.currentPrice, required this.imageUrl,required this.context});
}

class LoadWatchlist extends WatchListEvent {}
class RemoveFromWatchlist extends WatchListEvent {
  final String symbol;

  RemoveFromWatchlist(this.symbol);
}