import 'package:flutter/material.dart';
import 'package:poker_book/new_report_page.dart';

import 'app_user.dart';
import 'constants.dart';

/**
 * TODO
 * Figure out navbar
 * Graph page
 *  Build a list of tuples [(very first start date, profit), ..., (very last start date, proft)]
 *  $/hour
 *  $/session
 *  total profit
 *  total time played
 * Game Page
 *  Can edit or remove game from history
 *
 */


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List _games = AppUser.getGames();


  String timeDifference(String startTime, String endTime) {
    var startTime_ = Constants.dateFormat.parse(startTime);
    var endTime_ = Constants.dateFormat.parse(endTime);

    var diff = endTime_.difference(startTime_);

    return "${diff.inMinutes ~/ 60} hours ${diff.inMinutes % 60} minutes";
  }


  List<Widget> gameList() {
    List<Widget> widgets = [];
    for (Map m in _games.reversed) {
      widgets.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: ListTile(
            onTap: (){
              // go to game info page
            },
            title: Constants.text(timeDifference(m['startTime'], m['endTime']).toString(), color: Colors.white, fontSize: 16),
            subtitle: Constants.text(m['startTime'], color: Colors.white, fontSize: 12),
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
            trailing: int.parse(m['cashedOut']) > int.parse(m['buyin']) ?
            Constants.text("\$" + (int.parse(m['cashedOut']) - int.parse(m['buyin'])).toString() + ".00",
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)
            : Constants.text("\$" + (int.parse(m['cashedOut']) - int.parse(m['buyin'])).toString() + ".00",
                                     color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)
          ),
        ),
      );
    }
    return widgets;
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


  double getHourly() {
    return getProfit() / (getTotalTime() / 60);
  }

  @override
  void initState() {
    super.initState();
    AppUser.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                child: Row(
                  children: [
                    Constants.text("Report", color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                    Spacer(),
                    ElevatedButton(

                      child: const Icon(
                        Icons.add,
                        color: Colors.redAccent,
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewReport()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                    )
                  ],
                ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Constants.text("\$${getProfit()}", color: getHourly() > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Constants.text("\$${getHourly().toStringAsFixed(2)}/hour", color: getHourly() > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
              )
            ),
            Column(
              children: gameList()
            )
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}