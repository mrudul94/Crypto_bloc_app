import 'package:carousel_slider/carousel_slider.dart';
import 'package:cryptoapp/features/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    homeBloc.add(HomepageInitialFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: const Color.fromARGB(151, 5, 161, 21),
      // ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: BlocConsumer<HomeBloc, HomeState>(
          bloc: homeBloc,
          listenWhen: (previous, current) => current is HomeActionState,
          buildWhen: (previous, current) => current is! HomeActionState,
          listener: (context, state) {
            // Handle side effects here if needed, such as snackbars or navigation
          },
          builder: (context, state) {
            if (state is CryptoFetchSuccessfullState) {
              final successfullState = state;
              final cryptoDisplay = successfullState.cryptos.take(5).toList();
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity, // Full width container
                    height: 300,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(150, 3, 99, 12),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: CarouselSlider(
                      items: cryptoDisplay.map((crypto) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Image.network(
                                  crypto.image,
                                  width: 100,
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
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        viewportFraction: 1.0,
                      ),
                    ),
                  ),
                 
                ],
              );
            } else {
              return const SizedBox(); // Default empty widget if no state matches
            }
          },
        ),
      ),
    );
  }
}
