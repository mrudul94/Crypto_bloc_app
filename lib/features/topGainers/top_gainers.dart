
import 'package:cryptoapp/features/topGainers/bloc/top_gainers_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopGainers extends StatelessWidget {
  const TopGainers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopGainersBloc, TopGainersState>(
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
            physics: const NeverScrollableScrollPhysics(), // Prevent scrolling within parent
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 items per row
              crossAxisSpacing: 8.0, // Spacing between columns
              mainAxisSpacing: 8.0, // Spacing between rows
              childAspectRatio: 0.8, // Adjust for card height-to-width ratio
            ),
            itemCount: topGainers.length, // Dynamically set item count based on topGainers
            itemBuilder: (context, index) {
              var crypto = topGainers[index];
              return Card(
                color: const Color.fromARGB(146, 14, 19, 71), // Card background color
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white, width: 0), // Rounded corners
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
    );
  }
}

