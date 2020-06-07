import 'package:finacash/Helper/Movements_helper.dart';
import 'package:finacash/Widgets/AnimatedBottomNavBar.dart';
import 'package:finacash/Widgets/CardMovementItem.dart';
import 'package:finacash/screen/ExpensesSummary.dart';
import 'package:finacash/screen/HomePage.dart';
import 'package:finacash/screen/RecipesSummary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';

class InicialPage extends StatefulWidget {

  final List<BarItem> barItems = [
    BarItem(
      text: "Expenses",
      iconData: Icons.remove_circle_outline,
      color: Colors.pinkAccent,
    ),
    BarItem(
      text: "Home",
      iconData:  Icons.home,
      color: Colors.indigo,
    ),
    BarItem(
      text: "Recipes",
      iconData: Icons.add_circle_outline,
      color: Colors.teal,
    ),
  ];

  @override
  _InicialPageState createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  int selectedBarIndex = 1;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light
    ));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    List<Widget> telas =[
      ExpensesSummary(),
      HomePage(),
      RecipesSummary()
    ];

    return Scaffold(
      body: telas[selectedBarIndex],
      bottomNavigationBar: AnimatedBottomBar(
        barItems: widget.barItems,
        animationDuration: const Duration(milliseconds: 150),
        barStyle: BarStyle(
            fontSize: width * 0.045,
            iconSize: width * 0.07
        ),
        onBarTap: (index){
          setState(() {
            selectedBarIndex = index;
          });
        },
      ),
    );
  }
}
