import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'app_user.dart';
import 'constants.dart';
import 'home.dart';



class NewSession {

  DateTime? date;
  int? buyin;
  int? cashedOut;
  int? timeMinutes;

  NewSession();

  void editDate(DateTime date) {
    this.date = date;
  }

  void editBuyin(int buyin) {
    this.buyin = buyin;
  }

  void editCashedOut(int cashedOut) {
    this.cashedOut = cashedOut;
  }

  void editTimeMinutes(int timeMinutes) {
    this.timeMinutes = timeMinutes;
  }
}


NewSession newSession = NewSession();

class NewReport extends StatefulWidget {
  const NewReport({Key? key}) : super(key: key);

  @override
  State<NewReport> createState() => _NewReport();
}


class _NewReport extends State<NewReport> {


  final buyinText = TextEditingController();
  final cashedOutText = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;



  @override
  Widget build(BuildContext context) {


    void _showDatePicker(bool start) {
      // showCupertinoModalPopup is a built-in function of the cupertino library
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext builder) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: const Text(''),
                        onPressed: () {},
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 5.0,
                        ),
                      ),
                      CupertinoButton(
                        child: const Text(
                          'Confirm',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        onPressed: () {Navigator.of(context, rootNavigator: true).pop();},
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 5.0,
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .copyWith()
                        .size
                        .height * 0.25,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        brightness: Brightness.dark,
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: _startTime ?? DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            if (start) {
                               _startTime = val;
                            } else {
                              _endTime = val;
                            }
                          });
                        },
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                ]
            );
          }
      );
    }


    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(

        title: Constants.text("PokerBook", fontSize: 20),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.redAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _startTime != null ? Constants.dateFormat.format(_startTime!) : 'Start Time',
                    style: TextStyle(
                      color: _startTime != null ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
                ),
                onPressed: () {
                  _showDatePicker(true);
                  setState(() {

                  });
                },
              ),
            ),
            TextField(
              controller: buyinText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            keyboardType: TextInputType.number,
            onChanged: (text) {
                newSession.editBuyin(int.parse(text));
              },
              decoration: InputDecoration(
                fillColor: Colors.grey[900],
                filled: true,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                hintText: "Buyin",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
            TextField(
              controller: cashedOutText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.number,
              onChanged: (text) {
              newSession.editCashedOut(int.parse(text));
            },
            decoration: InputDecoration(
                fillColor: Colors.grey[900],
                filled: true,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                hintText: "Cashed Out",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
            SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _endTime != null ? Constants.dateFormat.format(_endTime!) : 'End Time',
                    style: TextStyle(
                      color: _endTime != null ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
                ),
                onPressed: () {
                  _showDatePicker(false);
                  setState(() {

                  });
                },
              ),
            ),
            SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
                onPressed: () {
                  print(buyinText.text);
                  Map game = {"buyin" : buyinText.text,
                    "cashedOut" : cashedOutText.text,
                    "startTime" : Constants.dateFormat.format(_startTime!),
                    "endTime" : Constants.dateFormat.format(_endTime!)};
                  AppUser.addGame(game);
                  setState(() {
                  });
                },
              ),
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