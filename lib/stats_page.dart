import 'dart:core';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'app_user.dart';



class PriceData {
  DateTime ts;
  int? profit;
  PriceData(this.ts, this.profit);
}

class UserNotableStats {
  int? totalProfit;
  late final double totalTimeSpent;
  late final double hourlyRate;
  late final double timePerSession;
  late final double winRate;
  final List _data = AppUser.getGames();

  UserNotableStats();

  List<PriceData> getPriceData() {
    List<PriceData> priceData = [];
    for (Map m in _data) {
      int profit = int.parse(m['cashout']) - int.parse(m['buyin']);
      DateTime startTime = m['startTime'];
      priceData.add(PriceData(startTime, profit));
    }
    priceData.sort((a, b) => a.ts.compareTo(b.ts));
    return priceData;
  }

}

UserNotableStats uns = UserNotableStats();

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPage();
}

class _StatsPage extends State<StatsPage> {

  List<PriceData> _priceData = [];

  @override
  void initState() {
    _priceData = uns.getPriceData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       body: SfCartesianChart(
         backgroundColor: Colors.black,
         primaryXAxis: DateTimeAxis(
             intervalType: DateTimeIntervalType.hours
         ),
         series: <ChartSeries<PriceData, DateTime>>[
           LineSeries<PriceData, DateTime>(
             color: Colors.blue,
            dataSource: _priceData,
            xValueMapper: (PriceData price, _) => price.ts,
            yValueMapper: (PriceData price, _) => price.profit)
         ]
       ),
      ),
    );
  }
}

