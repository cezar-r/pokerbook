import 'dart:core';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'app_user.dart';
import 'constants.dart';
import 'home.dart';


int totalProfit(List _games) {
  int tp = 0;
  for (Map m in _games) {
    tp += (int.parse(m['cashedOut']) - int.parse(m['buyin']));
  }
  return tp;
}

int totalTime(List _games) {
  int totalMinutes = 0;
  for (Map m in _games) {
    var startTime_ = Constants.dateFormat.parse(m['startTime']);
    var endTime_ = Constants.dateFormat.parse(m['endTime']);
    totalMinutes += endTime_.difference(startTime_).inMinutes;
  }
  return totalMinutes;
}

int totalGames(List _games) {
  return _games.length;
}

double winRatio(List _games) {
  int wins = 0;
  for (Map m in _games) {
    if (int.parse(m['buyin']) < int.parse(m['cashedOut'])) {
      wins += 1;
    }
  }
  return wins / _games.length;
}

int totalWins(List _games) {
  int wins = 0;
  for (Map m in _games) {
    if (int.parse(m['buyin']) < int.parse(m['cashedOut'])) {
      wins += 1;
    }
  }
  return wins;
}

int totalLosses(List _games) {
  int losses = 0;
  for (Map m in _games) {
    if (int.parse(m['buyin']) >= int.parse(m['cashedOut'])) {
      losses += 1;
    }
  }
  return losses;
}

double hourlyRate(List _games) {
  return totalProfit(_games) / (totalTime(_games) / 60);
}

double sessionRate(List _games) {
  return totalProfit(_games) / totalGames(_games);
}

String timeDifference(String startTime, String endTime) {
  var startTime_ = Constants.dateFormat.parse(startTime);
  var endTime_ = Constants.dateFormat.parse(endTime);
  var diff = endTime_.difference(startTime_);
  return "${diff.inMinutes ~/ 60} hours ${diff.inMinutes % 60} minutes";
}


class OverallPage extends StatelessWidget {
  final List _games = AppUser.getGames();
  OverallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = totalProfit(_games) > 0 ? Colors.greenAccent : Colors.redAccent;
    Row buildRow(String constText, String infoText) {
      return Row(
        children: [
          Constants.text(constText, color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          const Spacer(),
          Constants.text(infoText, color: color, fontSize: 20, fontWeight: FontWeight.bold)
        ],
      );
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildRow("Total Games", "${_games.length}"),
            buildRow("Overall Profit", "\$${totalProfit(_games)}"),
            buildRow("Total Time", "${totalTime(_games) ~/ 60} hours ${totalTime(_games) % 60} minutes"),
            buildRow("Hourly Rate", "\$${(totalProfit(_games) / (totalTime(_games) / 60)).toStringAsFixed(2)}/hour"),
            buildRow("Win/Loss", "${totalWins(_games)}/${totalLosses(_games)} (${(winRatio(_games) * 100).toStringAsFixed(0)}%)"),
            buildRow("Session Rate", "\$${sessionRate(_games)}/session"),
          ].map(
                (e) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: e,
            ),
          ).toList(),
        ),
      ),
    );
  }
}



class LocationsPage extends StatelessWidget {
  final List _games = AppUser.getGames();
  LocationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = totalProfit(_games) > 0 ? Colors.greenAccent : Colors.redAccent;
    Row buildRow(String constText, String infoText, Color color) {
      return Row(
        children: [
          Constants.text(constText, color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          const Spacer(),
          Constants.text(infoText, color: color, fontSize: 20, fontWeight: FontWeight.bold)
        ],
      );
    }

    Map<String, List> buildLocationMap() {
      Map<String, List> map = {};
      for (Map m in _games) {
        if (map.containsKey(m['location'])) {
          map[m['location']]?.add(m);
        } else {
          map[m['location']] = [m];
        }
      }
      return map;
    }

    List<Widget> buildContainers() {
      Map locationMap = buildLocationMap();
      List<Widget> widgets = [];

      locationMap.forEach((key, value) {

        Color color = totalProfit(value) > 0 ? Colors.greenAccent : Colors.redAccent;

        Row row = Row(
          children: [
            Constants.text(key, color: color, fontSize: 24, fontWeight: FontWeight.bold),
            Spacer(),
          ],
        );

        Column locationInfo = Column(
          children: [
            buildRow("Total Games", "${value.length}", color),
            buildRow("Overall Profit", "\$${totalProfit(value)}", color),
            buildRow("Total Time", "${totalTime(value) ~/ 60} hours ${totalTime(value) % 60} minutes", color),
            buildRow("Hourly Rate", "\$${(totalProfit(value) / (totalTime(value) / 60)).toStringAsFixed(2)}/hour", color),
            buildRow("Win/Loss", "${totalWins(value)}/${totalLosses(value)} (${(winRatio(value) * 100).toStringAsFixed(0)}%)", color),
            buildRow("Session Rate", "\$${sessionRate(value)}/session", color),
          ].map(
                (e) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: e,
            ),
          ).toList(),
        );

        Column mainColumn = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            row,
            locationInfo,
            SizedBox(height: 20,)
          ].map(
                (e) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: e,
            ),
          ).toList(),
        );

        widgets.add(mainColumn);
      });

      return widgets;
    }


    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: buildContainers(),
          ),
        ),
      ),
    );
  }
}







class GameTypesPage extends StatelessWidget {
  final List _games = AppUser.getGames();
  GameTypesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = totalProfit(_games) > 0 ? Colors.greenAccent : Colors.redAccent;
    Row buildRow(String constText, String infoText, Color color) {
      return Row(
        children: [
          Constants.text(constText, color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          const Spacer(),
          Constants.text(infoText, color: color, fontSize: 20, fontWeight: FontWeight.bold)
        ],
      );
    }

    Map<String, List> buildLocationMap() {
      Map<String, List> map = {};
      for (Map m in _games) {
        if (map.containsKey(m['gameType'])) {
          map[m['gameType']]?.add(m);
        } else {
          map[m['gameType']] = [m];
        }
      }
      return map;
    }

    List<Widget> buildContainers() {
      Map locationMap = buildLocationMap();
      List<Widget> widgets = [];

      locationMap.forEach((key, value) {

        Color color = totalProfit(value) > 0 ? Colors.greenAccent : Colors.redAccent;

        Row row = Row(
          children: [
            Constants.text(key, color: color, fontSize: 24, fontWeight: FontWeight.bold),
            Spacer(),
          ],
        );

        Column locationInfo = Column(
          children: [
            buildRow("Total Games", "${value.length}", color),
            buildRow("Overall Profit", "\$${totalProfit(value)}", color),
            buildRow("Total Time", "${totalTime(value) ~/ 60} hours ${totalTime(value) % 60} minutes", color),
            buildRow("Hourly Rate", "\$${(totalProfit(value) / (totalTime(value) / 60)).toStringAsFixed(2)}/hour", color),
            buildRow("Win/Loss", "${totalWins(value)}/${totalLosses(value)} (${(winRatio(value) * 100).toStringAsFixed(0)}%)", color),
            buildRow("Session Rate", "\$${sessionRate(value)}/session", color),
          ].map(
                (e) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: e,
            ),
          ).toList(),
        );

        Column mainColumn = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            row,
            locationInfo,
            SizedBox(height: 20,)
          ].map(
                (e) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: e,
            ),
          ).toList(),
        );

        widgets.add(mainColumn);
      });

      return widgets;


    }



    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: buildContainers(),
          ),
        ),
      ),
    );
  }
}







class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPage();
}

class _StatsPage extends State<StatsPage> {
  final List _games = AppUser.getGames();
  late Color color;
  int _currentPageIndex = 0;
  final List _children = [
    OverallPage(),
    LocationsPage(),
    GameTypesPage()
  ];


  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    color = totalProfit(_games) > 0 ? Colors.greenAccent : Colors.redAccent;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          // title: Constants.text("PokerBook", fontSize: 20, color: color),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: color,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
        ),
        body: _children[_currentPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex, // this will be set when a new tab is tapped
          backgroundColor: Colors.grey[900],
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money_rounded, color: _currentPageIndex == 0 ? color : Colors.grey[300]),
              title: Text('Overall', style: TextStyle(color: _currentPageIndex == 0 ? color : Colors.grey[300])),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pin_drop_rounded, color: _currentPageIndex == 1 ? color : Colors.grey[300]),
              title: Text('Locations', style: TextStyle(color: _currentPageIndex == 1 ? color : Colors.grey[300])),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted_rounded, color: _currentPageIndex == 2 ? color : Colors.grey[300]),
              title: Text('Games', style: TextStyle(color: _currentPageIndex == 2 ? color : Colors.grey[300])),
            )
          ],
        ),
      ),
    );
  }
}

