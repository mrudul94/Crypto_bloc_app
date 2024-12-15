import 'package:flutter/material.dart';
import 'package:cryptoapp/features/home/ui/home.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return   DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        
          bottomNavigationBar: Container(color: Colors.black,
            child: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.favorite), text: 'Wishlist'),
                Tab(icon: Icon(Icons.home), text: 'Home'),
                Tab(icon: Icon(Icons.search), text: 'Search'),
              ],
              indicatorColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xff999999),
              indicator: BoxDecoration(),
            ),
          ),
        
        bottomSheet: const TabBarView(
          children: [
            
            Center(child: Text("Wishlist Screen")), 
            HomeScreen(),
            Center(child: Text("Search Screen")),
          ],
        ),
      ),
    );
  }
}
