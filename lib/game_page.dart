import 'package:flutter/material.dart';

import 'app_user.dart';
import 'constants.dart';
import 'home.dart';
import 'new_report_page.dart';

class GamePage extends StatefulWidget {
  // const GamePage({Key? key}) : super(key: key);
  final Map game;

  const GamePage(this.game, {Key? key}) : super(key : key);

  @override
  State<GamePage> createState() => _GamePage(game);
}


class _GamePage extends State<GamePage> {

  Map game;
  _GamePage(this.game);



  int getTotalTime() {
    var startTime_ = Constants.dateFormat.parse(game['startTime']);
    var endTime_ = Constants.dateFormat.parse(game['endTime']);
    return endTime_.difference(startTime_).inMinutes;
  }

  int getProfit() {
    return int.parse(game['cashedOut']) - int.parse(game['buyin']);
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Color color = int.parse(game['buyin']) < int.parse(game['cashedOut']) ? Colors.greenAccent : Colors.redAccent;


    Row buildRow(String constText, String infoText) {
      return Row(
        children: [
          Constants.text(constText, color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          const Spacer(),
          Constants.text(infoText, color: color, fontSize: 20, fontWeight: FontWeight.bold)
        ],
      );
    }

    String timeDifference(String startTime, String endTime) {
      var startTime_ = Constants.dateFormat.parse(startTime);
      var endTime_ = Constants.dateFormat.parse(endTime);
      var diff = endTime_.difference(startTime_);
      return "${diff.inMinutes ~/ 60} hours ${diff.inMinutes % 60} minutes";
    }


    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildRow('Location', '${game['location']}'),
            buildRow('Type & Stake', '${game['gameType']}'),
            buildRow('Profit', '\$${getProfit()}'),
            buildRow('Hourly Rate', '\$${(getProfit() / (getTotalTime() / 60)).toStringAsFixed(2)}/hour'),
            buildRow('Buyin', '\$${game['buyin']}'),
            buildRow('Cashed Out', '\$${game['cashedOut']}'),
            buildRow('Start', game['startTime']),
            buildRow('End', game['endTime']),
            buildRow('Duration', timeDifference(game['startTime'], game['endTime'])),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                          side: BorderSide(
                            width: 2.0,
                            color: color,)
                      ),
                      onPressed: (){
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewReport("gamePage", game)),
                          );
                        });
                      },
                      child: const Icon(Icons.edit)
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                      ),
                      onPressed: (){
                        AppUser.removeGame(Constants.dateFormat.parse(game['startTime']));
                        setState(() {

                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyHomePage()),
                        );
                      },
                      child: const Icon(Icons.delete_outline_rounded)
                  ),
                ),
              ],
            ),
          ].map(
                (e) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: e,
            ),
          ).toList(),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }


}