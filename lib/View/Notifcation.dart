import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto/Admobservices/nativelinepage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Admobservices/admobs.dart';
import 'Addnotifcation.dart';

import 'navBar.dart';

import 'package:get/get.dart';

class NotifcationPage extends StatefulWidget {
  final item;
  const NotifcationPage({super.key, this.item});

  @override
  State<NotifcationPage> createState() => _NotifcationPageState();
}

class _NotifcationPageState extends State<NotifcationPage> {
  @override
  void initState() {
    // TODO: implement initState
    saveItemData();
    getItemData();
    saveImagePath();
    getImagePath();
    _createintersestadd();
    super.initState();
  }

  // void deleteNotification() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('percentage');
  //   prefs.remove('mark');
  //   prefs.remove('itemCurrentPrice');
  //   prefs.remove('itemId');
  //   prefs.remove('itemSymbol');
  //   prefs.remove('imagePath');
  //   prefs.remove('marketcap');
  //   setState(() {
  //     widget.item.remove();
  //   });
  // }

  // Function to save item data in shared preferences
  Future<void> saveItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('itemId', widget.item.id!);
    prefs.setString('itemSymbol', widget.item.symbol);
    prefs.setDouble('itemCurrentPrice', widget.item.currentPrice);
  }

  String? itemId;
  String? itemSymbol;
  double? itemCurrentPrice;
  List<String>? itemSparkline;
  double itemPercentage24h = 0.0;
  double marketcap = 0.0;
  String? itemImage;
  // Function to get item data from shared preferences
  getItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    itemId = prefs.getString('itemId');
    itemSymbol = prefs.getString('itemSymbol');
    itemCurrentPrice = prefs.getDouble('itemCurrentPrice');

    itemImage = prefs.getString('itemImage');
    setState(() {});
    return {
      'itemId': itemId,
      'itemSymbol': itemSymbol,
      'itemCurrentPrice': itemCurrentPrice,
    };
  }

  saveImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imagePath', widget.item.image);
    prefs.setDouble('percentage', widget.item.priceChange24H);
    prefs.setDouble('marketcap', widget.item.marketCapChangePercentage24H);
    prefs.setStringList('mark',
        widget.item.sparklineIn7D.price.map((e) => e.toString()).toList());
  }

  Future<dynamic> getImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    itemImage = prefs.getString('imagePath');
    itemPercentage24h = prefs.getDouble('percentage') ?? 0;
    marketcap = prefs.getDouble('marketcap') ?? 0;
    itemSparkline = prefs.getStringList('mark');
  }

  void _createintersestadd() {
    InterstitialAd.load(
        adUnitId: Admobservice.interestitialAndroid!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => intersialad = ad,
            onAdFailedToLoad: (LoadAdError error) => intersialad = null));
  }

  InterstitialAd? intersialad;

  void showinterstedadd() {
    if (intersialad != null) {
      intersialad!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createintersestadd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createintersestadd();
        },
      );
      intersialad!.show();
    }
  }

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _nativeAd = NativeAd(
      adUnitId: '/6499/example/native',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white12,
        callToActionTextStyle: NativeTemplateTextStyle(
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black38,
          backgroundColor: Colors.white70,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        onPressed: () {
          Get.to(AddNotifcation());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Notification Page',
          style: TextStyle(
              color: Theme.of(context).appBarTheme.titleTextStyle!.color,
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.iconTheme!.color,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: ((context) => NavBar())));
          },
        ),
      ),
      body: Column(
        children: [
          itemId == null
              ? Column(
                  children: [
                    SizedBox(
                      height: myHeight * 0.4,
                    ),
                    Center(
                      child: Text(
                        'No Coins Added',
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor, // Set the background color to blue
                          borderRadius: BorderRadius.circular(
                              10.0), // Set border radius for rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Add a shadow color
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 2), // Offset of the shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: myHeight * 0.05,
                                    width: myWidth * 0.02,
                                    child: Image.network(itemImage ?? ''),
                                  ),
                                ),
                                SizedBox(width: myWidth * 0.02),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        itemId!,
                                        style: TextStyle(
                                            fontSize: myWidth * 0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        itemSymbol!,
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
                                    height: myHeight * 0.03,
                                    child: Sparkline(
                                      data: itemSparkline
                                              ?.map((e) => double.parse(e))
                                              .toList() ??
                                          [],
                                      lineWidth: 1.0,
                                      lineColor: marketcap >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      fillMode: FillMode.below,
                                      fillGradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: const [0.0, 0.7],
                                        colors: marketcap >= 0
                                            ? [
                                                Colors.green,
                                                Colors.green.shade100
                                              ]
                                            : [Colors.red, Colors.red.shade100],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: myWidth * 0.02),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$ ' + itemCurrentPrice.toString(),
                                        style: TextStyle(
                                            fontSize: myWidth * 0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            itemPercentage24h
                                                    .toString()
                                                    .contains('-')
                                                ? "-\$" +
                                                    itemPercentage24h
                                                        .toStringAsFixed(2)
                                                        .toString()
                                                        .replaceAll('-', '')
                                                : "\$" +
                                                    itemPercentage24h
                                                        .toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: myWidth * 0.035,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: myWidth * 0.01),
                                          Text(
                                            marketcap.toStringAsFixed(2) + '%',
                                            style: TextStyle(
                                              fontSize: myWidth * 0.035,
                                              fontWeight: FontWeight.normal,
                                              color: marketcap >= 0
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
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: 7,
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 1,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 3 &&
                            _nativeAd != null &&
                            _nativeAdIsLoaded) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: 400,
                              height:
                                  260, // Adjust the height based on your needs
                              child: AdWidget(ad: _nativeAd!),
                            ),
                          );
                        }
                        return Text(
                          '',
                          style: TextStyle(fontSize: 24),
                        );
                      },
                    )
                  ],
                ),
        ],
      ),
    );
  }
}

///// importan code