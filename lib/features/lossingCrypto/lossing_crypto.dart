import 'package:cryptoapp/features/lossingCrypto/bloc/loss_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LossingCryptoWidget extends StatelessWidget {
  const LossingCryptoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LossBloc, LossState>(
      builder: (context, state) {
        if (state is LossInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LossingCryptoFetchSuccessfullState) {
          var cryptocurrencies = state.losscryptos.reversed.toList();

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Prevent scrolling within parent
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 items per row
              crossAxisSpacing: 8.0, // Spacing between columns
              mainAxisSpacing: 8.0, // Spacing between rows
              childAspectRatio: 0.8, // Adjust for card height-to-width ratio
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              var crypto = cryptocurrencies[index];
              return Card(color: const Color.fromARGB(146, 14, 19, 71), // Add card background color
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),side: const BorderSide(color: Colors.white,width: 0) // Rounded corners
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
                          overflow: TextOverflow.ellipsis
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
        } else if (state is LossingCryptoFetchFailureState) {
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
