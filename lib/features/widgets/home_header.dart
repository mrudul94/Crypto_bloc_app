import 'package:carousel_slider/carousel_slider.dart';
import 'package:cryptoapp/features/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget customHeader(BuildContext context, HomeBloc homeBloc) {
  return Container(
    height: 270, // Adjust the height as needed
    decoration: const BoxDecoration(
       gradient: LinearGradient(
        colors: [
          Color(0xFF2E7D32), // Green shade
          Colors.black,      // Black
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 40), // Adjust padding as needed
      child: BlocBuilder<HomeBloc, HomeState>(
        bloc: homeBloc,
        builder: (context, state) {
          if (state is CryptoFetchSuccessfullState) {
            final cryptoDisplay = state.cryptos.toList();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarouselSlider(
                  items: cryptoDisplay.map((crypto) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          crypto.image,
                          width: 90,
                        ),
                        Text(
                          crypto.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "\$${crypto.currentPrice}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${crypto.priceChangePercentage24H > 0 ? '+' : ''}${crypto.priceChangePercentage24H}%",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: crypto.priceChangePercentage24H > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ),
  );
}
