import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AcceleroMeter extends StatefulWidget {
  const AcceleroMeter({super.key});

  @override
  State<AcceleroMeter> createState() => _AcceleroMeterState();
}

class _AcceleroMeterState extends State<AcceleroMeter> {
  int _stepCount = 0;
  bool _isStepCounting = false;
  static const double _threshold = 10.0;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    accelerometerEvents.listen((AccelerometerEvent event) {
      double y = event.y;
      if (y > _threshold && !_isStepCounting) {
        setState(() {
          _isStepCounting = true;
          _stepCount++;
        });
      } else if (y < _threshold) {
        _isStepCounting = false;
      }
    });
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
              'Steps:',
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              '$_stepCount',
              style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
