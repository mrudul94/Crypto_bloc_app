import 'dart:developer';

import 'package:cryptoapp/features/home/repos/fetch_api_funtions.dart';
import 'package:cryptoapp/features/home/repos/watchlist_model.dart';
import 'package:cryptoapp/features/watchlist/bloc/watch_list_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../watchlist/bloc/watch_list_bloc.dart';



Future<void> handleAddToWatchlist(
  BuildContext context, 
   crypto
) async {
  bool success = await addToWatchlist(
    crypto.name, 
    crypto.symbol, 
    crypto.currentPrice,
    crypto.image,
  );

  if (success) {
    // If successfully added, dispatch the AddToWatchList event to the bloc
    context.read<WatchListBloc>().add(AddToWatchList(
      name: crypto.name,
      symbol: crypto.symbol,
      currentPrice: crypto.currentPrice,
      imageUrl: crypto.image,
      context: context
    ));
  } else {
    // Handle failure case if needed
    log("Failed to add to watchlist");
  }
}

