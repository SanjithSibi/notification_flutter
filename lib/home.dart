import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notification_flutter/local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

TextEditingController dateController = TextEditingController();
TextEditingController timeController = TextEditingController();
String selectedDateString = dateController.text;
String selectedTimeString = timeController.text;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

//  to listen to any notification clicked or not
  listenToNotifications() {
    print("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.pushNamed(context, '/another', arguments: event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Local Notifications")),
      body: Container(
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {
                  LocalNotifications.showSimpleNotification(
                      title: "Simple Notification",
                      body: "This is a simple notification",
                      payload: "This is simple data");
                },
                label: Text("Simple Notification"),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.timer_outlined),
                onPressed: () {
                  LocalNotifications.showPeriodicNotifications(
                      title: "Periodic Notification",
                      body: "This is a Periodic Notification",
                      payload: "This is periodic data");
                },
                label: Text("Periodic Notifications"),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
                onTap: () async {
                  // Show date picker
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (selectedDate != null) {
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(selectedDate);
                    print(dateController.text);
                  }
                },
              ),

              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time'),
                onTap: () async {
                  // Show time picker
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    timeController.text = selectedTime.format(context);
                    print(dateController.text + " " + timeController.text);
                  }
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.timer_outlined),
                onPressed: () {
                  LocalNotifications.showScheduleNotification(
                    title: "Schedule Notification",
                    body: "This is a Schedule Notification",
                    payload: "This is schedule data",
                    date: selectedDateString,
                    time: selectedTimeString,
                  );
                },
                label: Text("Schedule Notifications"),
              ),
              // to close periodic notifications
              ElevatedButton.icon(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    LocalNotifications.cancel(1);
                  },
                  label: Text("Close Periodic Notifcations")),
              ElevatedButton.icon(
                  icon: Icon(Icons.delete_forever_outlined),
                  onPressed: () {
                    LocalNotifications.cancelAll();
                  },
                  label: Text("Cancel All Notifcations"))
            ],
          ),
        ),
      ),
    );
  }
}
