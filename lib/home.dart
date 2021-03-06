import 'package:flutter/material.dart';
import 'package:poker_book/new_report_page.dart';
import 'package:poker_book/stats_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'app_user.dart';
import 'constants.dart';
import 'game_page.dart';

/// TODO
/// move start and end time to button
/// figure out graph display
/// add date range to graph

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
  late TrackballBehavior trackball;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  late String reportProfit;
  late String reportHourly;
  late TooltipBehavior _tooltipBehavior;

  // _MyHomePageState(){initState();}

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
            title: Constants.text(m['location'] + ' - ' + m['startTime'].substring(0, m['startTime'].length - 5), color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            subtitle: Constants.text(m['gameType'] + ' ' + timeDifference(m['startTime'], m['endTime']).toString(), color: Colors.white, fontSize: 12),
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
    widgets.add(const SizedBox(height: 30));
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
      int totalProfit = 0;
      for (Map m in _games) {
        int profit = int.parse(m['cashedOut']) - int.parse(m['buyin']);
        DateTime startTime = Constants.dateFormat.parse(m['startTime']);
        priceData.add(PriceData(startTime, totalProfit + profit));
        totalProfit += profit;
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
    trackball = TrackballBehavior(
      enable: true,
      lineType: TrackballLineType.vertical,
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: ChartAlignment.center,
      tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
      tooltipSettings: InteractiveTooltip(enable: true, format: 'point.x: \$point.y', color: Colors.black, borderColor: Colors.black),
      hideDelay: 100,
    );
    _tooltipBehavior = TooltipBehavior(enable: true);
    reportProfit = "\$" + getProfit().toString();
    reportHourly = "\$${getHourly().toStringAsFixed(2)}/hour";
    super.initState();
  }



  @override
  Widget build(BuildContext context) {


    AppUser.init();
    reportProfit = "\$" + getProfit().toString();
    reportHourly = "\$${getHourly().toStringAsFixed(2)}/hour";
    trackball = TrackballBehavior(
      enable: true,
      lineType: TrackballLineType.vertical,
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: ChartAlignment.center,
      tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
      tooltipSettings: InteractiveTooltip(enable: true, format: 'point.x: \$point.y', color: Colors.black, borderColor: Colors.black),
      hideDelay: 100,
    );
    _tooltipBehavior = TooltipBehavior(enable: true);
    return Scaffold(
      // appBar: Constants.appBar(),
      body : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Constants.text("Report", color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StatsPage()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Constants.text(reportProfit, color: getHourly() > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 22, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(height: 5,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Constants.text(reportHourly, color: getHourly() > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Constants.text("${(getWinsRatio() * 100).toStringAsFixed(2)}% win-rate", color: getWinsRatio() >= 0.5 ? Colors.greenAccent : Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold),
                        // ),
                      ],
                    )
                ),
               //  Padding(
               //    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
               //    child: Align(
               //        alignment: Alignment.centerLeft,
               //        child: Constants.text("Report", color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)
               //    ),
               //  ),
               // Align(
               //      alignment: Alignment.centerLeft,
               //      child: Constants.text(reportProfit, color: getHourly() > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 22, fontWeight: FontWeight.bold)
               //    ),
               //  const SizedBox(height: 5,),
               //  Align(
               //      alignment: Alignment.centerLeft,
               //      child: Constants.text(reportHourly, color: getHourly() > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
               //  ),
               //  const SizedBox(height: 10),
               //  // Align(
               //  //   alignment: Alignment.centerLeft,
               //  //   child: Constants.text("${(getWinsRatio() * 100).toStringAsFixed(2)}% win-rate", color: getWinsRatio() >= 0.5 ? Colors.greenAccent : Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold),
               //  // ),
                SfCartesianChart(
                  // onTrackballPositionChanging: (args) {
                  //   reportProfit = "\$" + args.chartPointInfo.chartDataPoint.yValue.toStringAsFixed(2);
                  //   reportHourly = '';
                  //   setState(() {
                  //
                  //   });
                  // },
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
                    ],
                  trackballBehavior: trackball,
                  tooltipBehavior: _tooltipBehavior,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Constants.text("Games", color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                    const Spacer(),
                    ElevatedButton(
                      child: Icon(
                        Icons.add,
                        color: getHourly() > 0 ? Colors.greenAccent : Colors.redAccent,
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  const NewReport("home", {})),
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