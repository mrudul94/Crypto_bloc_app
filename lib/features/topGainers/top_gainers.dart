// ignore_for_file: use_build_context_synchronously

import 'package:cryptoapp/features/topGainers/bloc/top_gainers_bloc.dart';
import 'package:cryptoapp/features/watchlist/bloc/watch_list_bloc.dart';
import 'package:cryptoapp/features/watchlist/bloc/watch_list_event.dart';
import 'package:cryptoapp/features/widgets/add_to_watch_onpress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../home/repos/watchlist_model.dart';

class TopGainers extends StatelessWidget {
  const TopGainers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WatchListBloc, WatchListState>(
      listener: (context, state) {
        if (state is WatchlistLoaded) {
          // If the watchlist is loaded, trigger a refresh or update the list.
          context.read<TopGainersBloc>().add(TopGainingFetchEvent());
        }
      },
      child: BlocBuilder<TopGainersBloc, TopGainersState>(
        builder: (context, state) {
          if (state is TopGainersInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TopGainingCryptoFetchSuccessfullState) {
            var cryptocurrencies = state.topcryptos;

            // Filter out cryptocurrencies that have a negative price change
            var topGainers = cryptocurrencies
                .where((crypto) => crypto.priceChangePercentage24H > 0)
                .toList();

            return GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Prevent scrolling within parent
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 items per row
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
                childAspectRatio: 0.8, // Adjust for card height-to-width ratio
              ),
              itemCount: cryptocurrencies.length <= 6
                  ? cryptocurrencies.length
                  : 6, // Dynamically set item count based on topGainers
              itemBuilder: (context, index) {
                var crypto = topGainers[index];
                return Stack(
                  children: [
                    SizedBox(
                      width: 510,
                      child: Card(
                        color: const Color.fromARGB(
                            146, 14, 19, 71), // Card background color
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                              color: Colors.white, width: 0), // Rounded corners
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              crypto.image,
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
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "${crypto.priceChangePercentage24H > 0 ? '+' : ''}${crypto.priceChangePercentage24H}%",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: crypto.priceChangePercentage24H > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      child: FutureBuilder<bool>(
                        future: _isItemInWatchlist(crypto
                            .symbol), // Check if the item exists in the watchlist
                        builder: (context, snapshot) {
                          Color iconColor = snapshot.hasData &&
                                  snapshot.data == true
                              ? Colors
                                  .red // If the item exists, color the icon red
                              : Colors.white; // Otherwise, keep the icon white

                          return IconButton(
                            onPressed: () async {
                              await handleAddToWatchlist(context, crypto);

                              // Reload the watchlist by dispatching the LoadWatchlist event
                              context
                                  .read<WatchListBloc>()
                                  .add(LoadWatchlist());
                            },
                            icon: Icon(Icons.favorite,
                                color:
                                    iconColor), // Dynamically change icon color
                          );
                        },
                      ),
                    )

                    // Helper function to check if the item is already in the watchlist
                  ],
                );
              },
            );
          } else if (state is TopGainingCryptoFetchFailureState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

Future<bool> _isItemInWatchlist(String symbol) async {
  final watchlistBox = await Hive.openBox<WatchlistItem>('watchlist');

  // Use a default WatchlistItem when the item isn't found
  final existingItem = watchlistBox.values.firstWhere(
    (item) => item.symbol == symbol,
    orElse: () =>
        WatchlistItem(name: '', symbol: '', currentPrice: 0.0, imageUrl: ''),
  );

  // If the existing item is a default item, return false
  return existingItem.symbol != '';
}
