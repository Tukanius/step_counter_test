import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step_counter1/accelerometer.dart';
import 'package:step_counter1/activityfl.dart';
// import 'package:step_counter1/activityfl.dart';
import 'package:step_counter1/biking.dart';
import 'package:step_counter1/flactivity.dart';
import 'package:step_counter1/healthpack.dart';
import 'package:step_counter1/main1.dart';
// import 'package:step_counter1/speedoforbike.dart';
// import 'package:step_counter1/main1.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Step Counter App',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? step;
  StreamSubscription<StepCount>? subscription;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _requestPermission() async {
    final PermissionStatus status =
        await Permission.activityRecognition.request();

    if (status == PermissionStatus.granted) {
      _initPedometer();
    } else {
      print('Permission denied');
    }
  }

  void _initPedometer() {
    subscription = Pedometer.stepCountStream.listen(
      (event) {
        print('===EVENT=====');
        print(event);
        print('===EVENT=====');
        setState(() {
          step = event.steps.toString();
        });
      },
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$step',
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HealthPack(),
                  ),
                );
              },
              child: Text('Speed for biking?'),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => UsingSensor(),
                  ),
                );
              },
              child: Text('SNAKE'),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AcceleroMeter(),
                  ),
                );
              },
              child: Text('AcceleroMeter'),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BikingDetector(),
                  ),
                );
              },
              child: Text('Biking?'),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FlActivity(),
                  ),
                );
              },
              child: Text('flActivity?'),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityRecognitionApp(),
                  ),
                );
              },
              child: Text('ACTIVITY WARNING CRASH?'),
            ),
          ],
        ),
      ),
    );
  }
}
