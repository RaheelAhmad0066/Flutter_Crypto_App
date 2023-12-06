import 'dart:async';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto/View/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Notifcation.dart';

class Itemm extends StatefulWidget {
  var items;
  int selected;
  Itemm({this.items, required this.selected});

  @override
  State<Itemm> createState() => _ItemmState();
}

class _ItemmState extends State<Itemm> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // Schedule the notification to be shown after 3 seconds
    final durat = Duration(minutes: widget.selected);
    Timer.periodic(durat, (Timer t) => showNotification());
    super.initState();
  }

  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      '${widget.items.id.toString()} \$${widget.items.currentPrice.toString()}/+(${widget.items.priceChange24H.toString().contains('-') ? "-\$" + widget.items.priceChange24H.toStringAsFixed(2).toString().replaceAll('-', '') : "\$" + widget.items.priceChange24H.toStringAsFixed(2)})',
      widget.items.marketCapChangePercentage24H.toStringAsFixed(2) + '%',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void updateNotification(String updatedText) {
    flutterLocalNotificationsPlugin.cancel(0);
    showNotification();
  }

  final _isLoading = false.obs;

  void _showSnackbarAndLoader() async {
    _isLoading.value = true;

    // Simulating a delay of 4 seconds
    await Future.delayed(Duration(seconds: 2));

    _isLoading.value = false;
    Get.back(); // Uncomment this line if you want to go back automatically
  }

  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 30);

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: myWidth * 0.05,
        vertical: myHeight * 0.01,
      ),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor:
                      Theme.of(context).dialogTheme.backgroundColor,
                  title: Row(
                    children: [
                      Image.network(
                        widget.items.image,
                        width: myHeight * 0.05,
                      ),
                      SizedBox(
                        width: myWidth * 0.04,
                      ),
                      Text(widget.items.id),
                    ],
                  ),
                  content: Text(
                      'it always says Update to 1 hour but we selected 5 minnutes see in image.'),
                  actions: [
                    InkWell(
                      onTap: () {
                        _isLoading.value ? null : _showSnackbarAndLoader();
                        updateNotification(widget.items.id);
                        showNotification();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => NotifcationPage(
                                      item: widget.items,
                                    ))),
                            ((route) => false));
                      },
                      child: Obx(
                        () => _isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : Container(
                                height: myHeight * 0.06,
                                width: myWidth * 0.7,
                                decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    'Update',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                      ),
                    )
                  ],
                );
              });

          showUpgradePopup(context);
        },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.items.marketCapRank.toString()),
              Expanded(
                child: Container(
                  height: myHeight * 0.05,
                  width: myWidth * 0.02,
                  child: Image.network(widget.items.image),
                ),
              ),
              SizedBox(width: myWidth * 0.02),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.items.id,
                      style: TextStyle(
                          fontSize: myWidth * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.items.symbol,
                      style: TextStyle(
                        fontSize: myWidth * 0.035,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: myWidth * 0.01),
              Expanded(
                flex: 1,
                child: Container(
                  height: myHeight * 0.05,
                  child: Sparkline(
                    data: widget.items.sparklineIn7D.price,
                    lineWidth: 1.0,
                    lineColor: widget.items.marketCapChangePercentage24H >= 0
                        ? Colors.green
                        : Colors.red,
                    fillMode: FillMode.below,
                    fillGradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.7],
                      colors: widget.items.marketCapChangePercentage24H >= 0
                          ? [Colors.green, Colors.green.shade100]
                          : [Colors.red, Colors.red.shade100],
                    ),
                  ),
                ),
              ),
              SizedBox(width: myWidth * 0.02),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$ ' + widget.items.currentPrice.toString(),
                      style: TextStyle(
                          fontSize: myWidth * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.items.priceChange24H.toString().contains('-')
                              ? "-\$" +
                                  widget.items.priceChange24H
                                      .toStringAsFixed(2)
                                      .toString()
                                      .replaceAll('-', '')
                              : "\$" +
                                  widget.items.priceChange24H
                                      .toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: myWidth * 0.035,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: myWidth * 0.01),
                        Text(
                          widget.items.marketCapChangePercentage24H
                                  .toStringAsFixed(2) +
                              '%',
                          style: TextStyle(
                            fontSize: myWidth * 0.035,
                            fontWeight: FontWeight.normal,
                            color:
                                widget.items.marketCapChangePercentage24H >= 0
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showUpgradePopup(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool packageUpgraded = prefs.getBool('packageUpgraded') ?? false;

    if (!packageUpgraded) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
            title: Text(widget.items.id),
            content: Text("Please select minutes input"),
            actions: [
              TextButton(
                onPressed: () {
                  // Perform upgrade logic here
                  // Once upgraded, set the flag in shared preferences
                  prefs.setBool('packageUpgraded', true);

                  // Close the popup
                  Navigator.pop(context);
                },
                child: Text("Upgrade"),
              ),
              TextButton(
                onPressed: () {
                  // Close the popup without upgrading
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
            ],
          );
        },
      );
    }
  }
}
