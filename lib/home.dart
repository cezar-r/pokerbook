import 'package:flutter/material.dart';
import 'package:poker_book/new_report_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'app_user.dart';
import 'constants.dart';
import 'game_page.dart';

/// TODO
/// Figure out navbar
/// Graph page
///  Build a list of tuples [(very first start date, profit), ..., (very last start date, proft)]
///  $/hour
///  $/session
///  total profit
///  total time played
/// Game Page
///  Can edit or remove game from history
///

class PriceData {
  DateTime ts;
  int? profit;
  PriceData(this.ts, this.profit);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List _games = AppUser.getGames();
  List<PriceData> _priceData = [];

  String timeDifference(String startTime, String endTime) {
    var startTime_ = Constants.dateFormat.parse(startTime);
    var endTime_ = Constants.dateFormat.parse(endTime);
    var diff = endTime_.difference(startTime_);
    return "${diff.inMinutes ~/ 60} hours ${diff.inMinutes % 60} minutes";
  }

  List<Widget> gameList() {
    List<Widget> widgets = [];
    _games.sort((a, b) => Constants.dateFormat.parse(a['startTime']).compareTo(Constants.dateFormat.parse(b['startTime'])));
    for (Map m in _games.reversed) {
      widgets.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GamePage(m)),
              );
            },
            title: Constants.text(m['startTime'], color: Colors.white, fontSize: 16),
            subtitle: Constants.text(timeDifference(m['startTime'], m['endTime']).toString(), color: Colors.white, fontSize: 12),
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            trailing: int.parse(m['cashedOut']) > int.parse(m['buyin']) ?
            Constants.text("+\$" + (int.parse(m['cashedOut']) - int.parse(m['buyin'])).toString() + ".00",
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)
            : Constants.text("-\$" + (int.parse(m['cashedOut']) - int.parse(m['buyin'])).toString().substring(1) + ".00",
                                     color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)
          ),
        ),
      );
    }
    return widgets;
  }

  List<PriceData> getPriceData() {
    List<PriceData> priceData = [];
    if (_games.isEmpty) {
      return <PriceData>[PriceData(DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day), 0), PriceData(DateTime.now(), 0)];
    }  else {
      _games.sort((a, b) =>
          Constants.dateFormat.parse(a['startTime']).compareTo(
              Constants.dateFormat.parse(b['startTime'])));
      int total_profit = 0;
      for (Map m in _games) {
        int profit = int.parse(m['cashedOut']) - int.parse(m['buyin']);
        DateTime startTime = Constants.dateFormat.parse(m['startTime']);
        priceData.add(PriceData(startTime, total_profit + profit));
        total_profit += profit;
      }
    }
    return priceData;
  }

  int getProfit() {
    int totalProfit = 0;
    for (Map m in _games) {
      totalProfit += int.parse(m['cashedOut']) - int.parse(m['buyin']);
    }
    return totalProfit;
  }

  int getTotalTime() {
    int totalMinutes = 0;
    for (Map m in _games) {
      var startTime_ = Constants.dateFormat.parse(m['startTime']);
      var endTime_ = Constants.dateFormat.parse(m['endTime']);
      totalMinutes += endTime_.difference(startTime_).inMinutes;
    }
    return totalMinutes;
  }

  double getWinsRatio() {
    int wins = 0;
    for (Map m in _games) {
      if (int.parse(m['buyin']) < int.parse(m['cashedOut'])) {
        wins += 1;
      }
    }
    return wins / _games.length;
  }


  double getHourly() {
    return getProfit() / (getTotalTime() / 60);
  }

  @override
  void initState() {
    _priceData = getPriceData();
    AppUser.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: Constants.appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Constants.text("Report", color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)
                ),
              ),
             Align(
                  alignment: Alignment.centerLeft,
                  child: Constants.text("\$${getProfit()}", color: getHourly() > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold)
                ),
              SizedBox(height: 5,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Constants.text("\$${getHourly().toStringAsFixed(2)}/hour", color: getHourly() > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Constants.text("${(getWinsRatio() * 100).toStringAsFixed(2)}% win-rate", color: getWinsRatio() >= 0.5 ? Colors.greenAccent : Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold),
              // ),
              SfCartesianChart(
                enableAxisAnimation: false,
                  backgroundColor: Colors.black,
                  plotAreaBorderColor: Colors.black,
                  plotAreaBackgroundColor: Colors.black,
                  primaryXAxis: DateTimeAxis(
                    intervalType: DateTimeIntervalType.days,
                    majorGridLines: MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    majorTickLines: MajorTickLines(
                      width: 0,
                    ),
                    majorGridLines: MajorGridLines(width: 0),
                    axisLine: AxisLine(width: 0),
                    // isVisible: false,
                  ),
                  series: <ChartSeries<PriceData, DateTime>>[
                    LineSeries<PriceData, DateTime>(
                        // color: Colors.blue,
                      color: getProfit() > 0 ? Colors.greenAccent : Colors.redAccent,
                        dataSource: _priceData,
                        xValueMapper: (PriceData price, _) => price.ts,
                        yValueMapper: (PriceData price, _) => price.profit)
                  ]
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Constants.text("Games", color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                  Spacer(),
                  ElevatedButton(
                    child: Icon(
                      Icons.add,
                      color: getHourly() > 0 ? Colors.greenAccent : Colors.redAccent,
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  NewReport("home", {})),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  )
                ],
              ),
              Column(
                children: gameList()
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}