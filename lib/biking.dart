import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BikingDetector extends StatefulWidget {
  @override
  _BikingDetectorState createState() => _BikingDetectorState();
}

class _BikingDetectorState extends State<BikingDetector> {
  int _stepCount = 0;
  bool _isBiking = false;
  static const double _bikingThreshold = 20.0; // Adjust as needed

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    accelerometerEvents.listen((AccelerometerEvent event) {
      double y = event.y;
      if (y > _bikingThreshold && !_isBiking) {
        setState(() {
          _isBiking = true;
          _stepCount++;
        });
      } else if (y < _bikingThreshold) {
        _isBiking = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biking Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Biking Status:',
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              _isBiking ? 'Biking' : 'Not Biking',
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                color: _isBiking ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Step Count:',
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              '$_stepCount',
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
