import 'package:cryptoapp/features/home/bloc/home_bloc.dart';
import 'package:cryptoapp/features/home/repos/watchlist_model.dart';
import 'package:cryptoapp/features/home/ui/splash_screen.dart';
import 'package:cryptoapp/features/lossingCrypto/bloc/loss_bloc.dart';
import 'package:cryptoapp/features/popular/bloc/popular_bloc.dart';
import 'package:cryptoapp/features/topGainers/bloc/top_gainers_bloc.dart';
import 'package:cryptoapp/features/watchlist/bloc/watch_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
   Hive.registerAdapter(WatchlistItemAdapter());

  // Open a Box
  // await Hive.openBox<WatchlistItem>('watchlist');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context)=>HomeBloc()..add(HomepageInitialFetchEvent()),),
        BlocProvider<PopularBloc>(create: (context)=>PopularBloc()..add(PopularCryptoFetchEvent()),),
        BlocProvider<LossBloc>(create: (context)=>LossBloc()..add(LossingCryptoFetchEvent()),),
        BlocProvider<TopGainersBloc>(create: (context)=>TopGainersBloc()..add(TopGainingFetchEvent()),),
        BlocProvider<WatchListBloc>(create: (context) => WatchListBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.teal),
        home: const SplashScreen(),
      ),
    );
  }
}
