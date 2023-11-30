import 'package:crypto/View/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/coinModel.dart';
import 'Components/Item3.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

class AddNotifcation extends StatefulWidget {
  const AddNotifcation({super.key});
  @override
  State<AddNotifcation> createState() => _AddNotifcationState();
}

int selectedNumber = 90;
List<CoinModel> filteredCoins = [];

class _AddNotifcationState extends State<AddNotifcation> {
  @override
  void initState() {
    // TODO: implement initState
    if (coinMarket != null) {
      filteredCoins.addAll(coinMarket!);
    }
    getCoinMarket();
    getCoinData();
    saveCoinData(filteredCoins);
    super.initState();
  }

// Save data to shared preferences
  Future<void> saveCoinData(List<CoinModel> coinData) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'coinData';
    final value = coinModelToJson(coinData);
    prefs.setString(key, value);
  }

// Retrieve data from shared preferences
  Future<List<CoinModel>> getCoinData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'coinData';
    final jsonString = prefs.getString(key);

    if (jsonString != null) {
      return coinModelFromJson(jsonString);
    } else {
      // Return an empty list if no data is found
      return [];
    }
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
    await saveCoinData(filteredCoins);
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

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Update Notifcation',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
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
                onChanged: (value) {
                  filterCoins(value);
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[300],
                  filled: true,
                  hintText: 'Search',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
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
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/image/search.png',
                                height: myHeight * 0.2,
                              ),
                              Center(
                                child: Text(
                                  'Please Update a Coine\n Up to 5,10,30 minut',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
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
                              selected: selectedNumber,
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
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildNumberBox(5),
                  buildNumberBox(10),
                  buildNumberBox(30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  buildNumberBox(int number) {
    return GestureDetector(
      onTap: () {
        // Update the selected number when a box is tapped
        if (selectedNumber != 0) {
          // Do something with the selected number (store it in a variable)
          print('Selected Number: $selectedNumber');
        } else {
          // User hasn't selected any number
          print('Please select a number first.');
        }
        setState(() {
          selectedNumber = number;
        });
        showSuperTooltip(context, number);
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedNumber == number ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        width: 80,
        height: 80,
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 20,
              color: selectedNumber == number ? Colors.white : Colors.black,
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
              'Do you want to set a bitcoin \n notification for 5 minutes?: $number',
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
