import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/donut_chart.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/components/percent_indicator.dart';
import 'package:agitprint/components/screen_size.dart';
import 'package:agitprint/components/wave_progress.dart';
import 'package:agitprint/constants.dart';
import 'package:agitprint/extract/accounts.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

var data = [
  new DataPerItem('Hotel & Restaurant', 24, Colors.indigo),
  new DataPerItem('Travelling', 40, Colors.pinkAccent),
];

var series = [
  new charts.Series(
    domainFn: (DataPerItem clickData, _) => clickData.name,
    measureFn: (DataPerItem clickData, _) => clickData.percent,
    colorFn: (DataPerItem clickData, _) => clickData.color,
    id: 'Item',
    data: data,
  ),
];

class BodyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 20,
        top: 30,
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                "Bem-vindo, \n" + currentPeopleLogged.name,
                style: GoogleTextStyles.customTextStyle(fontSize: 20),
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.blackShade3,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Account(
                            people: currentPeopleLogged,
                          )));
                })
          ],
        ),
        SizedBox(
          height: 30,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Gastos",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "    July 2018",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 15,
            right: 20,
          ),
          height:
              screenAwareSize(_media.longestSide <= 775 ? 180 : 130, context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 6,
                spreadRadius: 10,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 180,
                width: 160,
                child: DonutPieChart(
                  series,
                  animate: true,
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    donutCard(Colors.greenAccent, "Hotel & Restaurant"),
                    donutCard(Colors.pinkAccent, "Travelling"),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Orçamento",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "    July",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontFamily: "Varela",
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 15,
            right: 20,
          ),
          padding: EdgeInsets.all(10),
          height: screenAwareSize(45, context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 6,
                spreadRadius: 10,
              )
            ],
          ),
          child: LinearPercentIndicator(
            width: screenAwareSize(
                _media.width - (_media.longestSide <= 775 ? 100 : 160),
                context),
            lineHeight: 20.0,
            percent: 0.68,
            backgroundColor: Colors.grey.shade300,
            progressColor: Color(0xFF1b52ff),
            animation: true,
            animateFromLastPercent: true,
            alignment: MainAxisAlignment.spaceEvenly,
            animationDuration: 1000,
            linearStrokeCap: LinearStrokeCap.roundAll,
            center: Text(
              "68.0%",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "Fluxo de caixa",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            inherit: true,
            letterSpacing: 0.4,
          ),
        ),
        vaweCard(
          context,
          "Ganhos",
          200,
          1,
          Colors.grey.shade100,
          Color(0xFF716cff),
        ),
        vaweCard(
          context,
          "Gastos",
          3210,
          -1,
          Colors.grey.shade100,
          Color(0xFFff596b),
        ),
      ],
    );
  }

  Widget vaweCard(BuildContext context, String name, double amount, int type,
      Color fillColor, Color bgColor) {
    return Container(
      margin: EdgeInsets.only(
        top: 15,
        right: 20,
      ),
      padding: EdgeInsets.only(left: 15),
      height: screenAwareSize(80, context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            spreadRadius: 10,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              WaveProgress(
                screenAwareSize(45, context),
                fillColor,
                bgColor,
                80,
              ),
              Text(
                "80%",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "${type > 0 ? "" : "-"} \$ ${amount.toString()}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget donutCard(Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 0,
            top: 18,
            right: 10,
          ),
          height: 15,
          width: 15,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            inherit: true,
          ),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        )
      ],
    );
  }
}
