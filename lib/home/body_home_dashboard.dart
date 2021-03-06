import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/donut_chart.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/components/percent_indicator.dart';
import 'package:agitprint/components/screen_size.dart';
import 'package:agitprint/components/wave_progress.dart';
import 'package:agitprint/constants.dart';
import 'package:agitprint/extract/accounts.dart';
import 'package:agitprint/models/budget_period.dart';
import 'package:agitprint/models/people.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class BodyHomeDashboard extends StatefulWidget {
  final PeopleModel people;

  const BodyHomeDashboard({Key key, this.people}) : super(key: key);
  @override
  _BodyHomeDashboardState createState() => _BodyHomeDashboardState();
}

class _BodyHomeDashboardState extends State<BodyHomeDashboard> {
  PeopleModel _peopleModel = PeopleModel.empty();

  @override
  void initState() {
    super.initState();
    _peopleModel = PeopleModel.fromPeople(widget.people);
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;

    _peopleModel.budgetPeriod = _peopleModel.budgetPeriod
        .where((element) => element.period == currentPeriod)
        .toList();

    BudgetPeriodModel _budget;
    if (_peopleModel.budgetPeriod.isEmpty) {
      _budget = BudgetPeriodModel.empty();
    } else {
      _budget = _peopleModel.budgetPeriod.first;
    }
    int _totalPurchasesPercent = _budget.totalPurchases == 0
        ? 0
        : ((_budget.totalPurchases * 100) /
                (_budget.totalPurchases + _budget.totalActions))
            .floor();

    int _totalActionsPercent =
        _budget.totalActions == 0 ? 0 : 100 - _totalPurchasesPercent;

    int _totalBudgetPercent = _budget.totalEarns == 0
        ? _budget.totalWastes == 0
            ? 0
            : 100
        : ((_budget.totalWastes * 100) / _budget.totalEarns).floor();

    final series = [
      new charts.Series(
        domainFn: (DataPerItem clickData, _) => clickData.name,
        measureFn: (DataPerItem clickData, _) => clickData.percent,
        colorFn: (DataPerItem clickData, _) => clickData.color,
        id: 'Item',
        data: [
          DataPerItem('Compras', _totalPurchasesPercent, Colors.indigo),
          DataPerItem('A????es', _totalActionsPercent, Colors.pinkAccent),
        ],
      ),
    ];

    return RefreshIndicator(
      child: ListView(
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
                  "Ol??, " + widget.people.name,
                  style: GoogleTextStyles.customTextStyle(fontSize: 20),
                ),
              ),
              /* Row(
                children: [
                  Text(
                    NumberFormat.simpleCurrency(locale: "pt_BR")
                        .format(_peopleModel.balance),
                    style: GoogleTextStyles.customTextStyle(fontSize: 20),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.blackShade3,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Account(
                                  people: _peopleModel,
                                )));
                      }),
                ],
              ) */
            ],
          ),
          SizedBox(
            height: 30,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Saldo",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.only(
                right: 20,
              ),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Account(
                                people: _peopleModel,
                              )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            NumberFormat.simpleCurrency(locale: "pt_BR")
                                .format(_peopleModel.balance),
                            style: GoogleTextStyles.customTextStyle(
                                color: _peopleModel.balance.isNegative
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 21,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.blackShade3,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Verba",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '    ' +
                      months[DateTime.now().month - 1] +
                      ' ' +
                      DateTime.now().year.toString(),
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
            padding: EdgeInsets.all(10),
            height: screenAwareSize(50, context),
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
              width: _media.width - 100,
              lineHeight: 20.0,
              percent: (_totalBudgetPercent / 100) > 1
                  ? 1
                  : _totalBudgetPercent / 100,
              backgroundColor: Colors.grey.shade300,
              progressColor: Color(0xFF1b52ff),
              animation: true,
              animateFromLastPercent: true,
              alignment: MainAxisAlignment.spaceEvenly,
              animationDuration: 1000,
              linearStrokeCap: LinearStrokeCap.roundAll,
              center: Text(
                _totalBudgetPercent.toString() + '%',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Distribui????o da verba",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '    ' + months[DateTime.now().month - 1],
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
                      donutCard(
                          Colors.indigo,
                          "Compras - " +
                              _totalPurchasesPercent.toString() +
                              '%'),
                      donutCard(Colors.pinkAccent,
                          "A????es - " + _totalActionsPercent.toString() + '%'),
                    ],
                  ),
                )
              ],
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
          vaweCard(context, "Cr??ditos", _budget.totalEarns.toDouble(), 1,
              Colors.grey.shade100, Color(0xFF716cff), 100),
          vaweCard(context, "D??bitos", _budget.totalWastes.toDouble(), -1,
              Colors.grey.shade100, Color(0xFFff596b), _totalBudgetPercent),
          SizedBox(
            height: 30,
          ),
        ],
      ),
      onRefresh: () {
        String peopleToRefresh = currentPeopleLogged.id == _peopleModel.id
            ? currentPeopleLogged.id
            : _peopleModel.id;
        return FirebaseFirestore.instance
            .collection('pessoas')
            .doc(peopleToRefresh)
            .get()
            .then((value) {
          PeopleModel people = PeopleModel.fromFirestoreDocument(value);
          setState(() {
            if (currentPeopleLogged.id == _peopleModel.id)
              currentPeopleLogged = PeopleModel.fromPeople(people);
            _peopleModel = PeopleModel.fromPeople(people);
          });
        });
      },
    );
  }

  Widget vaweCard(BuildContext context, String name, double amount, int type,
      Color fillColor, Color bgColor, int percent) {
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
                percent.toDouble(),
              ),
              Text(
                percent.toString() + '%',
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
                NumberFormat.simpleCurrency(locale: "pt_BR").format(amount),
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
