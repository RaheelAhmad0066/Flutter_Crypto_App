import 'dart:async';

import 'package:crypto/Admobservices/nativelinepage.dart';
import 'package:crypto/View/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/coinModel.dart';
import 'Components/Item3.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

class AddNotifcation extends StatefulWidget {
  const AddNotifcation({super.key});
  @override
  State<AddNotifcation> createState() => _AddNotifcationState();
}

Timer? notificationTimer;
List<CoinModel> filteredCoins = [];

class _AddNotifcationState extends State<AddNotifcation> {
  @override
  void initState() {
    // TODO: implement initState
    if (coinMarket != null) {
      filteredCoins.addAll(coinMarket!);
    }

    getCoinMarket();
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  bool isRefreshing = true;
  void filterCoins(String query) async {
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

  var coinMarketList;
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

      // Show a notification when the data is updated
    } else {
      print(response.statusCode);
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.black.withOpacity(0.1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Notifcation',
          style: TextStyle(
              color: Theme.of(context).appBarTheme.titleTextStyle!.color,
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).appBarTheme.iconTheme!.color),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: myHeight * 0.09,
            ),
            Container(
              height: myHeight * 0.06,
              width: myWidth * 0.8,
              child: TextField(
                controller: searchController,
                textAlignVertical: TextAlignVertical(y: 0.9),
                textAlign: TextAlign.left,
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
              height: myHeight * 0.06,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.36,
              child: isRefreshing == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffF004BFE),
                      ),
                    )
                  : filteredCoins == null || filteredCoins.length == 0
                      ? Center(
                          child: Image.asset(
                            'assets/image/seachlist.gif',
                            height: myHeight * 0.2,
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredCoins
                              .length, // Use the actual length of the data
                          shrinkWrap: false, // Allow the ListView to scroll
                          controller: ScrollController(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Itemm(
                              items: filteredCoins[index],
                              selected: selectedDuration,
                            );
                          },
                        ),
            ),
            SizedBox(
              height: myHeight * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please selct a minut for update your notifaction',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: myHeight * 0.07,
            ),
            ContainerRow(),
          ],
        ),
      ),
    );
  }

  // buildNumberBox(int number) {
  //   return GestureDetector(
  //     onTap: () {
  //       print('$storedNumber');
  //       setState(() {
  //         storedNumber = number;
  //       });

  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: storedNumber == number ? color : Colors.grey[300],
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       width: 80,
  //       height: 80,
  //       child: Center(
  //         child: Text(
  //           '$number',
  //           style: TextStyle(
  //             fontSize: 20,
  //             color: storedNumber == number ? Colors.white : Colors.black,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

int selectedDuration = 15;

class ContainerRow extends StatefulWidget {
  @override
  _ContainerRowState createState() => _ContainerRowState();
}

class _ContainerRowState extends State<ContainerRow> {
  // Default value 5 minutes

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        buildContainer(5),
        buildContainer(10),
        buildContainer(30),
      ],
    );
  }

  Widget buildContainer(int value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDuration = value;
        });
        showSuperTooltip(context, value);
        print('$selectedDuration');
      },
      child: Container(
        width: 90,
        height: 50,
        decoration: BoxDecoration(
          color: selectedDuration == value ? color : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '$value',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void showSuperTooltip(BuildContext context, int number) {
    final overlay = Overlay.of(context);

    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 8,
        left: MediaQuery.of(context).size.width / 2 - 75,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Do you want to set a bitcoin \n notification for $number minutes?: ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Wait for a moment and then remove the overlay
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
