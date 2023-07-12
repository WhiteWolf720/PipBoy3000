// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const ClockApp());
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pip Boy 3000',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.compact,
      ),
      home: const Scaffold(
        body: SafeArea(
          child: PipBoy(),
        ),
      ),
    );
  }
}

class PipBoy extends StatelessWidget {
  const PipBoy({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return PipOs(mode);
          },
        );
      },
    );
  }
}


class PipOs extends StatefulWidget {

  final WearMode mode;

  const PipOs(this.mode, {super.key});

  @override
  _PipOsState createState() => _PipOsState();
}

class _PipOsState extends State<PipOs> {
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now().toUtc().subtract(const Duration(hours: 6)); // Mexico's time offset
    });

    Timer(
      const Duration(seconds: 1) - Duration(milliseconds: _currentTime.millisecond),
      _updateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('hh:mm:ss a');
    final dateString = DateFormat('MMM dd, yyyy').format(_currentTime);
    final timeString = timeFormat.format(_currentTime);

    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              dateString,
              style: TextStyle(
                color: widget.mode == WearMode.active ? Colors.green : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Image.asset( widget.mode == WearMode.active ?
            'assets/vault_boy.gif' : 'assets/vault_boy_white.gif',
            width: 80,
            height: 80,
            ),
            const SizedBox(height: 10),
            Text(
              timeString,
              style: TextStyle(
                color: widget.mode == WearMode.active ? Colors.green : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
