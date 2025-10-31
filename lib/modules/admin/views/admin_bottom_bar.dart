import 'package:flutter/material.dart';
import 'package:green_leaf/modules/admin/views/admin_home_screen.dart';
import 'package:green_leaf/modules/admin/views/manage_customers.dart';
import 'package:green_leaf/modules/admin/views/manage_orders.dart';
import 'package:green_leaf/modules/admin/views/manage_products.dart';
import 'package:green_leaf/modules/admin/views/manage_report_screen.dart';

class AdminBottomBar extends StatefulWidget {
  @override
  _AdminBottomBarState createState() => _AdminBottomBarState();
}

class _AdminBottomBarState extends State<AdminBottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [];
  @override
  void initState() {
    super.initState();
    _screens.addAll([
      AdminHomeScreen(onTabChange: _onItemTapped),
      ManageProducts(),
      ManageOrderScreen(),
      ManageCustomers(),
      ManageReportsScreen(),
    ]);
  }

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
                  "assets/images/product.png",
                  width: 27,
                  height: 27,
                ),
                index: 1,
              ),
              buildNavItem(
                icon: Image.asset(
                  "assets/images/order.png",
                  width: 35,
                  height: 35,
                ),
                index: 2,
              ),
              buildNavItem(
                icon: Image.asset(
                  "assets/images/customer.png",
                  width: 35,
                  height: 35,
                ),
                index: 3,
              ),
              buildNavItem(
                icon: Image.asset(
                  "assets/images/report.png",
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
