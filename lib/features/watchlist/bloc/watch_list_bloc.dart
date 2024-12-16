// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/features/home/repos/watchlist_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'watch_list_event.dart';
part 'watch_list_state.dart';

class WatchListBloc extends Bloc<WatchListEvent, WatchListState> {
  WatchListBloc() : super(WatchListInitial()) {
    on<AddToWatchList>(_addToWatchList);
    on<LoadWatchlist>(_loadWatchlist);

    
    
    _initializeWatchlist();
  }

  void _initializeWatchlist() {
    // Ensure the Hive box is open
    Hive.openBox<WatchlistItem>('watchlist').then((_) {
      add(LoadWatchlist());
    }).catchError((e) {
      addError('Failed to initialize watchlist: $e');
    });
  }

  Future<void> _loadWatchlist(LoadWatchlist event, Emitter<WatchListState> emit) async {
    try {
      final watchlistBox = Hive.box<WatchlistItem>('watchlist');
      final watchlist = watchlistBox.values.toList();
      emit(WatchlistLoaded(watchlist));
    } catch (e) {
      emit(WatchListError('Failed to load watchlist: $e'));
    }
  }

  Future<void> _addToWatchList(AddToWatchList event, Emitter<WatchListState> emit) async {
  emit(WatchlistLoading()); // Emit loading state

  try {
    final watchlistBox = Hive.box<WatchlistItem>('watchlist');
    final newItem = WatchlistItem(
      name: event.name,
      symbol: event.symbol,
      currentPrice: event.currentPrice,
      imageUrl: event.imageUrl,
    );

    String message; // Snackbar message
    Color snackBarColor; // Snackbar color

    final existingIndex = watchlistBox.values.toList().indexWhere((item) => item.symbol == event.symbol);
    
    if (existingIndex != -1) {
      // Remove the existing item
      await watchlistBox.deleteAt(existingIndex);
      message = "${event.name} removed from Watchlist.";
      snackBarColor = Colors.red; // Red for removal
    } else {
      // Add the new item
      await watchlistBox.add(newItem);
      message = "${event.name} added to Watchlist.";
      snackBarColor = Colors.green; // Green for addition
    }

    // Fetch the updated list
    final updatedWatchlist = watchlistBox.values.toList();
    emit(WatchlistLoaded(updatedWatchlist));

    // Use ScaffoldMessenger to show Snackbar with dynamic color
    ScaffoldMessenger.of(event.context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: snackBarColor, // Set the background color
        duration: const Duration(seconds: 2),
      ),
    );
  } catch (e) {
    emit(WatchListError('Failed to update watchlist: $e'));
  }
}


  
}
