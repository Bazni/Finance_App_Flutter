import 'package:finacash/Helper/Movements_helper.dart';
import 'package:finacash/Widgets/TimeLineItem.dart';
import 'package:flutter/material.dart';

class RecipesSummary extends StatefulWidget {
  @override
  _RecipesSummaryState createState() => _RecipesSummaryState();
}

class _RecipesSummaryState extends State<RecipesSummary> {

  MovementsHelper movementsHelper = MovementsHelper();
  List<Movements> listMovements = List();

  _allMovPorTipo() {
    movementsHelper.getAllMovementsByType("r").then((list) {
      setState(() {
        listMovements = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _allMovPorTipo();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green.withOpacity(0.8),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: width * 0.05,top: width * 0.2),
              child: Text("Recipes",
                style: TextStyle(
                    color: Colors.white ,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.08
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.08),
              child: SizedBox(
                width: width,
                height: height * 0.74,
                child: ListView.builder(
                  itemCount: listMovements.length,
                  itemBuilder: (context, index){
                    List movReverse = listMovements.reversed.toList();
                    Movements mov = movReverse[index];
                    if (movReverse[index] == movReverse.last) {
                      return TimeLineItem(mov: mov, colorItem: Colors.green[900],isLast: true,);
                    }else {
                      return TimeLineItem(mov: mov,colorItem: Colors.green[900],isLast: false,);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}