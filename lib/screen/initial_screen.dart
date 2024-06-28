import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo_list_screen.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      setState(() {
        _isFirstLaunch = true;
      });
      await prefs.setBool('isFirstLaunch', false);
    } else {
      _navigateToTodoListScreen();
    }
  }

  void _navigateToTodoListScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => TodoListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isFirstLaunch
          ? PermissionRequestWidget(onPermissionsGranted: _navigateToTodoListScreen)
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class PermissionRequestWidget extends StatelessWidget {
  final VoidCallback onPermissionsGranted;

  PermissionRequestWidget({required this.onPermissionsGranted});

  Future<void> _requestPermissions(BuildContext context) async {
    var notificationStatus = await Permission.notification.request();
    var scheduleExactAlarmStatus = await Permission.scheduleExactAlarm.request();

    if (notificationStatus.isGranted && scheduleExactAlarmStatus.isGranted) {
      onPermissionsGranted();
    } else {
      // Handle permission denial
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permissions Required'),
          content: Text('Please grant the necessary permissions to proceed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _requestPermissions(context),
        child: Text('Allow Notifications and Alarm Tone'),
      ),
    );
  }
}
