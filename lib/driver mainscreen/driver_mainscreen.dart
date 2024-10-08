import 'package:flutter/material.dart';

import '../driver tabpages/earning_tab.dart';
import '../driver tabpages/home_tab.dart';
import '../driver tabpages/profile_tab.dart';
import '../driver tabpages/rating_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin
{

  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index)
  {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  void initState(){
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children:[
          HomeTabPage(),
          DriverEarningPage(),
          DriverRatingPage(),
          ProfileTabPage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items:const [
          BottomNavigationBarItem(
            icon:Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.credit_card),
            label: "Earnings",
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.star),
            label: "Ratings",
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.person),
            label: "Profile",
          ),
        ],

        unselectedItemColor: Colors.white38,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),

    );
  }
}


