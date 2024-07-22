import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalSeconds = 1500;
  bool isRunning = false;
  bool isRefresing = false;
  int totalPomodoros = 0;
  late Timer timer;

  void onTick(Timer timer) {
    setState(() {
      if (totalSeconds == 0 && isRefresing == false) {
        totalPomodoros = totalPomodoros + 1;
        isRefresing = true;
        totalSeconds = 300;
      } else if (totalSeconds == 0) {
        onPausePressed();
        totalSeconds = 1500;
        isRefresing = false;
      } else {
        totalSeconds = totalSeconds - 1;
      }
    });
  }

  void onStartPressed() {
    timer = Timer.periodic(
      // 설정한 주기 마다 지점한 함수를 실행시킴.
      const Duration(milliseconds: 1000),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onRefreshPressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
      isRefresing = false;
      totalSeconds = 1500;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isRefresing
          ? const Color(0xFF49BACE)
          : Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      isRefresing
                          ? 'REST TIME'
                          : (isRunning ? 'FOCUS TIME' : 'PAUSE'),
                      style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800)),
                  Text(format(totalSeconds),
                      style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: 89,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          Flexible(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 120,
                      color: Theme.of(context).cardColor,
                      onPressed: isRunning ? onPausePressed : onStartPressed,
                      icon: Icon(isRunning
                          ? Icons.pause_circle_filled_outlined
                          : Icons.play_circle_fill_outlined),
                    ),
                    IconButton(
                      iconSize: 40,
                      color: Theme.of(context).cardColor,
                      onPressed: onRefreshPressed,
                      icon: const Icon(Icons.refresh_outlined),
                    ),
                  ],
                ),
              )),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 60,
                            color: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
