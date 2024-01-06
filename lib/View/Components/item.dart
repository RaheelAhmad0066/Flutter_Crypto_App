import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../Admobservices/admobs.dart';
import '../selectCoin.dart';

class Item extends StatefulWidget {
  var items;

  Item({
    this.items,
  });

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  void initState() {
    // TODO: implement initState
    _createintersestadd();

    super.initState();
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

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (contest) => SelectCoin(
                        selectItem: widget.items,
                      )));
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createintersestadd();
          setState(() {
            isLoading = false;
          });

          // Navigate forward even when ad fails to show
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (contest) => SelectCoin(
                        selectItem: widget.items,
                      )));
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

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (contest) => SelectCoin(
                    selectItem: widget.items,
                  )));
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
