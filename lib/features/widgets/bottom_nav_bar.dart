import 'package:flutter/material.dart';
import 'package:cryptoapp/features/home/ui/home.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  const DefaultTabController(
      length: 3,
      child: Scaffold(
        
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'Wishlist'),
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.search), text: 'Search'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xff999999),
          ),
        
        body: TabBarView(
          children: [
            // Add the corresponding screen for each tab
            Center(child: Text("Wishlist Screen")), 
            HomeScreen(),
            Center(child: Text("Search Screen")),
          ],
        ),
      ),
    );
  }
}
