import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

class FlActivity extends StatefulWidget {
  const FlActivity({super.key});

  @override
  State<FlActivity> createState() => _FlActivityState();
}

class _FlActivityState extends State<FlActivity> {
  final _activityStreamController = StreamController<Activity>();
  StreamSubscription<Activity>? _activityStreamSubscription;

  void _onActivityReceive(Activity activity) {
    dev.log('Activity Detected >> ${activity.toJson()}');
    _activityStreamController.sink.add(activity);
  }

  void _handleError(dynamic error) {
    dev.log('Catch Error >> $error');
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final activityRecognition = FlutterActivityRecognition.instance;
// Create a timer that ticks every second
      _timer = Timer.periodic(Duration(seconds: 1), _incrementSeconds);
      // Check if the user has granted permission. If not, request permission.
      PermissionRequestResult reqResult;
      reqResult = await activityRecognition.checkPermission();
      if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
        dev.log('Permission is permanently denied.');
        return;
      } else if (reqResult == PermissionRequestResult.DENIED) {
        reqResult = await activityRecognition.requestPermission();
        if (reqResult != PermissionRequestResult.GRANTED) {
          dev.log('Permission is denied.');
          return;
        }
      }

      // Subscribe to the activity stream.
      _activityStreamSubscription = activityRecognition.activityStream
          .handleError(_handleError)
          .listen(_onActivityReceive);
    });
  }

  void _incrementSeconds(Timer timer) {
    setState(() {
      _seconds++;
    });
  }

  late Timer _timer;
  int _seconds = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Flutter Activity Recognition'), centerTitle: true),
      body: Column(
        children: [
          SizedBox(
            height: 500,
            width: 500,
            child: _buildContentView(),
          ),
          Text(
            'Seconds: $_seconds',
            style: TextStyle(fontSize: 24.0),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _activityStreamController.close();
    _activityStreamSubscription?.cancel();
    super.dispose();
  }

  Widget _buildContentView() {
    return StreamBuilder<Activity>(
        stream: _activityStreamController.stream,
        builder: (context, snapshot) {
          print("===== =====SNAPSHOT===== =====");
          print(snapshot.data.toString());
          print("===== =====SNAPSHOT===== =====");

          final updatedDateTime = DateTime.now();
          final content = snapshot.data?.toJson().toString() ?? '';

          return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                Text('•\t\tActivity (updated: $updatedDateTime)'),
                SizedBox(height: 10.0),
                Text(content)
              ]);
        });
  }
}
