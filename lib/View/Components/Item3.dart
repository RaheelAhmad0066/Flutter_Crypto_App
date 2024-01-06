import 'dart:async';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto/View/Addnotifcation.dart';
import 'package:crypto/View/RegisterScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:workmanager/workmanager.dart';
import '../../Admobservices/admobs.dart';
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
    notifcation();
    _createintersestadd();
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      "1",
      "simpleTask",
      frequency:
          Duration(minutes: selectedDuration), // Adjust the frequency as needed
    );
    super.initState();
  }

  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) {
      showNotification();
      return Future.value(true);
    });
  }

  void notifcation() {
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
    // Register the background handler for Firebase Messaging
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    // Listen for FCM messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the FCM message when the app is in the foreground
      showNotification();
    });
    // Schedule the notification to be shown after 3 seconds
    final durat = Duration(minutes: selectedDuration);
    Timer.periodic(durat, (Timer t) => showNotification());
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await showNotification();
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
    await Future.delayed(Duration(seconds: 1));

    _isLoading.value = false;
    Get.back(); // Uncomment this line if you want to go back automatically
  }

  bool isLoading = false;
  InterstitialAd? intersialad;
  void _createintersestadd() {
    InterstitialAd.load(
      adUnitId: Admobservice.interestitialAndroid!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            intersialad = ad;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            intersialad = null;
            isLoading = false;
          });
        },
      ),
    );
  }

  void showinterstedadd() {
    if (intersialad != null) {
      setState(() {
        isLoading = true;
      });

      intersialad!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createintersestadd();
          setState(() {
            isLoading = false;
          });

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
                        width: 33,
                      ),
                      SizedBox(
                        width: 34,
                      ),
                      Text(widget.items.id),
                    ],
                  ),
                  content:
                      Text('Change notification to 5 minutes or 10 and 30'),
                  actions: [
                    InkWell(
                      onTap: () {
                        _isLoading.value ? null : _showSnackbarAndLoader();
                        updateNotification(widget.items.id);
                        showNotification();
                        notifcation();
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
                                height: 56,
                                width: 307,
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
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createintersestadd();
          setState(() {
            isLoading = false;
          });

          // Navigate forward even when ad fails to show
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
                        width: 33,
                      ),
                      SizedBox(
                        width: 34,
                      ),
                      Text(widget.items.id),
                    ],
                  ),
                  content:
                      Text('Change notification to 5 minutes or 10 and 30'),
                  actions: [
                    InkWell(
                      onTap: () {
                        _isLoading.value ? null : _showSnackbarAndLoader();
                        updateNotification(widget.items.id);
                        showNotification();
                        notifcation();
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
                                height: 56,
                                width: 307,
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
        },
      );

      intersialad!.show();
    } else {
      // Handle the case when intersialad is null
      // This could happen if the ad fails to load
      // Navigate forward in this case as well
      setState(() {
        isLoading = false;
      });

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
              title: Row(
                children: [
                  Image.network(
                    widget.items.image,
                    width: 33,
                  ),
                  SizedBox(
                    width: 34,
                  ),
                  Text(widget.items.id),
                ],
              ),
              content: Text('Change notification to 5 minutes or 10 and 30'),
              actions: [
                InkWell(
                  onTap: () {
                    _isLoading.value ? null : _showSnackbarAndLoader();
                    updateNotification(widget.items.id);
                    showNotification();
                    notifcation();
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
                            height: 56,
                            width: 307,
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
          showinterstedadd();
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
}
