import 'package:cryptoapp/features/home/bloc/home_bloc.dart';
import 'package:cryptoapp/features/lossingCrypto/lossing_crypto.dart';
import 'package:cryptoapp/features/topGainers/top_gainers.dart';
import 'package:cryptoapp/features/widgets/home_header.dart';
import 'package:cryptoapp/features/popular/popular_crypto.dart';
import 'package:flutter/material.dart';

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
    // Dispatch events to fetch data on screen load
    homeBloc.add(HomepageInitialFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader(context, homeBloc),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Popular Cryptos',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 350,
              child: PopularCryptoWidget(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Top Gainers',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),
            ),
               const SizedBox(height: 350,
                child: TopGainers()),
            
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Top Losers',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 350,
              width: double.infinity,
              child: LossingCryptoWidget(),
            )
          ],
        ),
      ),
    );
  }
}
