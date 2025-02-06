import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:message_read_app/home/home.dart';
import 'package:message_read_app/home/message_read.dart';


class BottomPages extends StatefulWidget {
  const BottomPages({super.key});

  @override
  State<BottomPages> createState() => _BottomPagesState();
}

class _BottomPagesState extends State<BottomPages> {
  int currentTabIndex = 0;
  late List<Widget> pages;

  late Widget currentPage;
  late HomePages home;
  late MessageReadPages cart;

  @override
  void initState() {
    home =const HomePages();
    cart =const MessageReadPages();
    pages = [home, cart,];
    currentPage = home;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 500),
        backgroundColor: Colors.black,
        color:  Colors.white,
        height: 65,
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items:const [
          Icon(
            Icons.phone,
            color: Colors.black,
            size: 30,
          ),
          Icon(
            Icons.message,
            color: Colors.black,
            size: 30,
          ),
         
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
