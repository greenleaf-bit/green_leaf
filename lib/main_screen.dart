import 'package:flutter/material.dart';
import 'package:green_leaf/modules/user/views/cart_screen.dart';
import 'package:green_leaf/modules/user/views/home_screen.dart';
import 'package:green_leaf/modules/user/views/order_screen.dart';
import 'package:green_leaf/modules/user/views/profile_screen.dart';
import 'package:green_leaf/modules/user/views/scanner_screen.dart';

class CustomBottomBar extends StatefulWidget {
  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    OrderScreen(),
    ScannerScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildNavItem({required Widget icon, required int index}) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: _selectedIndex == index
                  ? Colors.green
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 4),
          icon, // <- yahan direct widget aa jayega (Icon ya Image.asset)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: _screens[_selectedIndex],

      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 30),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            _onItemTapped(2);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.qr_code_scanner, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        notchMargin: 8.0,
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -1),
              ),
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(
                icon: Image.asset(
                  "assets/icons/home_icon.png",
                  width: 27,
                  height: 27,
                ),
                index: 0,
              ),
              buildNavItem(
                icon: Image.asset(
                  "assets/icons/order_icon.png",
                  width: 35,
                  height: 35,
                ),
                index: 1,
              ),
              SizedBox(width: 40),
              buildNavItem(
                icon: Image.asset(
                  "assets/icons/cart_icon.png",
                  width: 35,
                  height: 35,
                ),
                index: 3,
              ),
              buildNavItem(
                icon: Image.asset(
                  "assets/icons/profile_icon.png",
                  width: 35,
                  height: 35,
                ),
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
