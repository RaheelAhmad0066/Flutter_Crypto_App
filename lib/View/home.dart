import 'dart:async';

import 'package:crypto/Constant/themeconstant.dart';
import 'package:crypto/Theme/Themeconstant.dart';
import 'package:crypto/View/Notifcation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';

import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/coinModel.dart';
import 'Components/item.dart';
import 'Components/item2.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

bool isNotificationMuted = false;
List<String> notifications = [];
List<CoinModel>? coinMarket;

class _HomeState extends State<Home> {
  bool isRefreshing = true;

  var coinMarketList;
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

    // Fetch crypto data initially
    getCoinMarket();

    const durat = Duration(minutes: 5);

    Timer.periodic(durat, (Timer t) => showNotification());
    if (coinMarket != null) {
      filteredCoins.addAll(coinMarket!);
    }
    super.initState();
  }

// Function to show a notification
  Future<void> showNotification() async {
    // Select a single coin for simplicity, you can modify this part based on your app's logic
    if (isNotificationMuted) {
      return; // Do not show notification if notifications are muted
    }
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    for (CoinModel coin in coinMarket!) {
      // Use the coin's image as the image path
      String imagePath = 'assets/images/${coin.image}.png';
      // Add the notification to the list

      // Build the notification details with the coin image
      final BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(
        FilePathAndroidBitmap(imagePath),
        contentTitle:
            '${coin.id.toString()} \$${coin.currentPrice.toString()}/+(${coin.priceChange24H.toString().contains('-') ? "-\$" + coin.priceChange24H!.toStringAsFixed(2).toString().replaceAll('-', '') : "\$" + coin.priceChange24H!.toStringAsFixed(2)})',
        summaryText:
            '${coin.marketCapChangePercentage24H!.toStringAsFixed(2) + '%'}',
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id', // Change this to your channel ID
          'your_channel_name', // Change this to your channel name
          // Change this to your channel description
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
        ),
      );

      // Show the notification
      await flutterLocalNotificationsPlugin.show(
        0,
        'Crypto Data Updated',
        'Details about the crypto data', // You can customize this message as needed
        platformChannelSpecifics,
        payload: 'item x',
      );
    }
  }

  Future<void> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isRefreshing = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefreshing = false;
    });
    if (response.statusCode == 200) {
      var x = response.body;
      coinMarketList = coinModelFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
    }
  }

  // List<Coin> coinMarket = []; // replace 'Coin' with your actual data type
  TextEditingController searchController = TextEditingController();
  List<CoinModel> filteredCoins = [];

  void filterCoins(String query) {
    List<CoinModel> filteredList = [];
    if (coinMarket != null && query.isNotEmpty) {
      for (CoinModel coin in coinMarket!) {
        if (coin.name!.toLowerCase().contains(query.toLowerCase()) ||
            coin.symbol!.toLowerCase().contains(query.toLowerCase())) {
          filteredList.add(coin);
        }
      }
    } else if (coinMarket != null) {
      filteredList.addAll(coinMarket!);
    }

    setState(() {
      filteredCoins.clear();
      filteredCoins.addAll(filteredList);
    });
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Theme",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                    icon: (themeProvider.themeMode == ThemeMode.light)
                        ? Icon(
                            Icons.lightbulb_sharp,
                          )
                        : Icon(Icons.lightbulb_sharp),
                  ),
                ],
              ),
              SizedBox(
                height: myHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/image/cry.png',
                          height: myHeight * 0.09,
                        ),
                        Text(
                          'rypto Track',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: Colors.white, fontSize: 27),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(NotifcationPage());
                      },
                      child: Container(
                          padding: EdgeInsets.all(myWidth * 0.02),
                          height: myHeight * 0.05,
                          width: myWidth * 0.1,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: badges.Badge(
                              badgeContent: Text(
                                '',
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Image.asset('assets/icons/3.1.png'))),
                    )
                  ],
                ),
              ),
              Container(
                height: myHeight * 0.06,
                width: myWidth * 0.8,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    filterCoins(value);
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    filled: true,
                    hintText: 'Search',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xff3B3B3B),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(26.0)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(26.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: myHeight * 0.02,
              ),
              Container(
                height: myHeight * 0.7,
                width: myWidth,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          color: Colors.grey.shade300,
                          spreadRadius: 3,
                          offset: Offset(0, 3))
                    ],
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                child: Column(
                  children: [
                    SizedBox(
                      height: myHeight * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Row(
                        children: [
                          Text(
                            'Market',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: myWidth * 0.6,
                          ),
                          InkWell(
                            onTap: () {
                              getCoinMarket();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.3),
                              child: Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.36,
                      child: isRefreshing == true
                          ? Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: Color(0xffF004BFE),
                                  ),
                                  SizedBox(
                                    height: myHeight * 0.06,
                                  ),
                                  Text(
                                    'Many api requests\n for a moment....',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )
                          : filteredCoins == null || filteredCoins.length == 0
                              ? Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height *
                                          0.06),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/image/search.png',
                                          height: myHeight * 0.2,
                                        ),
                                        Text(
                                          'Please Search a Market Coine',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: filteredCoins
                                      .length, // Use the actual length of the data
                                  shrinkWrap:
                                      false, // Allow the ListView to scroll
                                  controller: ScrollController(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Item(
                                      items: filteredCoins[index],
                                    );
                                  },
                                ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                      child: Row(
                        children: [
                          Text(
                            'Top Gainers',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.01,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: myWidth * 0.03),
                        child: isRefreshing == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xffF004BFE),
                                ),
                              )
                            : coinMarket == null || coinMarket!.length == 0
                                ? Padding(
                                    padding: EdgeInsets.all(myHeight * 0.08),
                                    child: Center(
                                      child: Text(
                                        'Attention this Api is free, so you cannot send multiple requests per second, please wait and try again later.',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: coinMarket!.length,
                                    itemBuilder: (context, index) {
                                      return Item2(
                                        item: coinMarket![index],
                                      );
                                    },
                                  ),
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.01,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
