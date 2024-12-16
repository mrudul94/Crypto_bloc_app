// ignore_for_file: use_build_context_synchronously

import 'package:cryptoapp/features/watchlist/bloc/watch_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../home/repos/watchlist_model.dart';
import 'bloc/watch_list_event.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Padding(
          padding: EdgeInsets.only(top: 30, right: 35),
          child: Center(
            child: Text(
              'WatchList',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), // Back icon with white color
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: BlocBuilder<WatchListBloc, WatchListState>(
          builder: (context, state) {
            if (state is WatchListInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WatchlistLoaded) {
              var cryptocurrencies = state.cryptos;

              return Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Color(0xFF2E7D32)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: cryptocurrencies.length,
                  itemBuilder: (context, index) {
                    var crypto = cryptocurrencies[index];
                    return Stack(
                      children: [
                        SizedBox(
                          width: 510,
                          child: Card(
                            color: const Color.fromARGB(146, 14, 19, 71),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  crypto.imageUrl,
                                  width: 60,
                                  height: 60,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  crypto.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: FutureBuilder<bool>(
                            future: _isItemInWatchlist(crypto.symbol),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              Color iconColor = snapshot.data == true
                                  ? Colors.red
                                  : Colors.white;

                              return IconButton(
                                onPressed: () async {
                                  // Access the watchlist using Hive
                                  final watchlistBox = await Hive.openBox<WatchlistItem>('watchlist');
                                  final existingItemKey = watchlistBox.keys.firstWhere(
                                    (key) => watchlistBox.get(key)?.symbol == crypto.symbol,
                                    orElse: () => null,
                                  );

                                  if (existingItemKey == null) {
                                    // If the item doesn't exist in the watchlist, add it
                                    await watchlistBox.add(WatchlistItem(
                                      name: crypto.name,
                                      symbol: crypto.symbol,
                                      currentPrice: crypto.currentPrice,
                                      imageUrl: crypto.imageUrl,
                                    ));
                                    print("Item Added to Watchlist: ${crypto.name}");
                                  } else {
                                    // If the item exists in the watchlist, remove it by key
                                    await watchlistBox.delete(existingItemKey);
                                    print("Item Removed from Watchlist: ${crypto.name}");
                                  }

                                  // Reload the watchlist after updating it
                                  context.read<WatchListBloc>().add(LoadWatchlist());
                                },
                                icon: Icon(Icons.favorite, color: iconColor),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Future<bool> _isItemInWatchlist(String symbol) async {
    final watchlistBox = await Hive.openBox<WatchlistItem>('watchlist');
  
    // Use a default WatchlistItem when the item isn't found
    final existingItem = watchlistBox.values.firstWhere(
      (item) => item.symbol == symbol,
      orElse: () => WatchlistItem(name: '', symbol: '', currentPrice: 0.0, imageUrl: ''),
    );
  
    // If the existing item is a default item, return false
    return existingItem.symbol != '';
  }
}
