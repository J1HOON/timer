import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: timer_home());
  }
}

class timer_home extends StatefulWidget {
  const timer_home({
    super.key,
  });

  @override
  State<timer_home> createState() => _timer_homeState();
}

class _timer_homeState extends State<timer_home> {
  static int totalTime = 60;
  late Timer timer; //타이머 클래스
  int times = totalTime; //시간 초기 설정
  String timeView = '0:01:00';
  bool isRunning = false;

  void timeStart() {
    if (isRunning) {
      //타이머 동작중
      timeStop();
    } else {
      //타이머 pause중
      if (times > 0) {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            timeView = Duration(seconds: times).toString().split('.')[0];
            times--;
          });
          if (times < 0) {
            timeStop();
            isRunning = !isRunning;
          }
        });
      }
    }
    isRunning = !isRunning;
  }

  void timeReset() {
    setState(() {
      timeStop();
      timeView = '0:01:00';
      times = totalTime;
      isRunning = false;
    });
  }

  void timeStop() {
    setState(() {
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
              flex: 1,
              child: SizedBox(
                height: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TimeAddBtn(60, Colors.blue),
                    TimeAddBtn(30, Colors.redAccent),
                    TimeAddBtn(-30, Colors.greenAccent),
                  ],
                ),
              )),
          Flexible(
              flex: 3,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: Center(
                    child: Text(
                  timeView,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                )),
              )),
          Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.blue,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          //시간을 흐르게 하는 버튼
                          iconSize: 50,
                          onPressed: timeStart, //마지막에 괄호가 없음
                          icon: isRunning
                              ? const Icon(
                                  Icons.pause_circle_outline,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white,
                                )),
                      IconButton(
                          //시간을 초기화해주는 버튼
                          iconSize: 50,
                          onPressed: timeReset,
                          icon: const Icon(
                            Icons.stop_circle_outlined,
                            color: Color.fromARGB(255, 255, 255, 255),
                          )),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  GestureDetector TimeAddBtn(int time, Color color) {
    return GestureDetector(
      onTap: () => addTime(time),
      child: Container(
        width: 100,
        height: 30,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text('+${time}s')),
      ),
    );
  }

  void addTime(int time) {
    times = times + time;
    if (times < 0) {
      times = 0;
      timeStop();
    }
    timeView = Duration(seconds: times).toString().split('.')[0];
  }
}
