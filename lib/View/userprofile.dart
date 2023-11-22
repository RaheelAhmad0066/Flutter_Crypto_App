import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Admobservices/admobs.dart';
import '../Model/UserModal.dart';
import 'home.dart';

class Userprofile extends StatefulWidget {
  final users;
  const Userprofile({super.key, this.users});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  BannerAd? _bannerAd;
  InterstitialAd? intersialad;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    // TODO: implement initState
    _createbannerad();
    _createintersestadd();
    showinterstedadd();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    super.initState();
  }

  void _createbannerad() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: Admobservice.banneradunit!,
        listener: Admobservice.bannerAdListener,
        request: const AdRequest())
      ..load();
  }

  void _createintersestadd() {
    InterstitialAd.load(
        adUnitId: Admobservice.interestitialAndroid!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => intersialad = ad,
            onAdFailedToLoad: (LoadAdError error) => intersialad = null));
  }

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

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'User Profile',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: myHeight * 0.1,
          ),
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://st3.depositphotos.com/15648834/17930/v/450/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg'),
            ),
          ),
          SizedBox(height: 20),
          Text(
            loggedInUser.firstName.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            loggedInUser.email.toString(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: myHeight * 0.04,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 1,
                    offset: Offset(2, 2),
                    color: const Color.fromARGB(255, 208, 204, 204))
              ], color: Colors.white, borderRadius: BorderRadius.circular(22)),
              child: SwitchListTile(
                title: Text('Mute Notifications'),
                value: isNotificationMuted,
                onChanged: (value) {
                  setState(() {
                    isNotificationMuted = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bannerAd == null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(ad: _bannerAd!),
            ),
    );
  }
}
