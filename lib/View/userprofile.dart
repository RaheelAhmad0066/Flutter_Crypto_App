import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/View/LoginScreen.dart';
import 'package:crypto/View/RegisterScreen.dart';
import 'package:crypto/View/navBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences _prefs;
  @override
  void initState() {
    // TODO: implement initState
    _createbannerad();
    _createintersestadd();
    _initSharedPreferences();
    _fetchUserData();
    showinterstedadd();
    super.initState();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _fetchUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (snapshot.exists) {
      this.loggedInUser = UserModel.fromMap(snapshot.data()!);
      setState(() {
        _saveUserDataInSharedPreferences(
          displayName: loggedInUser.firstName,
          email: loggedInUser.email,
        );
      });
    }
  }

  Future<void> _saveUserDataInSharedPreferences({
    required String? displayName,
    required String? email,
  }) async {
    if (displayName != null) {
      await _prefs.setString('displayName', displayName);
    }

    if (email != null) {
      await _prefs.setString('email', email);
    }
  }

  void _createbannerad() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: Admobservice.banneradunit!,
        listener: Admobservice.bannerAdListener,
        request: const AdRequest())
      ..load();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await _auth.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: ((context) => LoginScreen())),
        (route) => false);
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
            Get.to(NavBar());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: myHeight * 0.1,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 40,
                  child: user?.photoURL != null
                      ? Image.network(user!.photoURL.toString())
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.black,
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              user?.displayName ?? loggedInUser.firstName ?? 'Name...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              user?.email ?? loggedInUser.email ?? '',
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
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1,
                          offset: Offset(2, 2),
                          color: const Color.fromARGB(255, 208, 204, 204))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22)),
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
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: InkWell(
                onTap: () {
                  signOut();
                },
                child: Container(
                    height: myHeight * 0.07,
                    width: myWidth * 0.9,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurRadius: 1,
                          offset: Offset(2, 2),
                          color: Color.fromARGB(255, 208, 204, 204))
                    ], color: color, borderRadius: BorderRadius.circular(22)),
                    child: Center(
                      child: Text(
                        'Logout',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                      ),
                    )),
              ),
            ),
          ],
        ),
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
