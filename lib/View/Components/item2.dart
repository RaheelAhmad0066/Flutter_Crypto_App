import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../Admobservices/admobs.dart';
import '../selectCoin.dart';

class Item2 extends StatefulWidget {
  var item;
  Item2({this.item});

  @override
  State<Item2> createState() => _Item2State();
}

class _Item2State extends State<Item2> {
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

          Navigator.push(context, MaterialPageRoute(builder: (contest) {
            return SelectCoin(
              selectItem: widget.item,
            );
          }));
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createintersestadd();
          setState(() {
            isLoading = false;
          });

          // Navigate forward even when ad fails to show
          Navigator.push(context, MaterialPageRoute(builder: (contest) {
            return SelectCoin(
              selectItem: widget.item,
            );
          }));
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

      Navigator.push(context, MaterialPageRoute(builder: (contest) {
        return SelectCoin(
          selectItem: widget.item,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: myWidth * 0.03, vertical: myHeight * 0.02),
      child: GestureDetector(
        onTap: () {
          showinterstedadd();
        },
        child: Container(
          padding: EdgeInsets.only(
            left: myWidth * 0.06,
            right: myWidth * 0.06,
            top: myHeight * 0.02,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: myHeight * 0.035,
                  child: Image.network(widget.item.image)),
              SizedBox(
                height: myHeight * 0.02,
              ),
              Text(
                widget.item.id,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: myHeight * 0.01,
              ),
              Row(
                children: [
                  Text(
                    widget.item.priceChange24H.toString().contains('-')
                        ? "-\$" +
                            widget.item.priceChange24H
                                .toStringAsFixed(2)
                                .toString()
                                .replaceAll('-', '')
                        : "\$" + widget.item.priceChange24H.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    width: myWidth * 0.03,
                  ),
                  Text(
                    widget.item.marketCapChangePercentage24H
                            .toStringAsFixed(2) +
                        '%',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: widget.item.marketCapChangePercentage24H >= 0
                            ? Colors.green
                            : Colors.red),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
