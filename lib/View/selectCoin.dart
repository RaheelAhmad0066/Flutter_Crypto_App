import 'dart:convert';
import 'package:crypto/View/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Model/chartModel.dart';

// ignore: must_be_immutable
class SelectCoin extends StatefulWidget {
  var selectItem;

  SelectCoin({this.selectItem});

  @override
  State<SelectCoin> createState() => _SelectCoinState();
}

class _SelectCoinState extends State<SelectCoin> {
  late TrackballBehavior trackballBehavior;

  @override
  void initState() {
    getChart();
    trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectItem.id,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02,
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: Image.network(widget.selectItem.image),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectItem.id,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              widget.selectItem.symbol,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$' + widget.selectItem.currentPrice.toString(),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          widget.selectItem.marketCapChangePercentage24H
                                  .toString() +
                              '%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: widget.selectItem
                                        .marketCapChangePercentage24H >=
                                    0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                  child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: myWidth * 0.05, vertical: myHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('MARKET CAP',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                            SizedBox(
                              height: myHeight * 0.01,
                            ),
                            Text('\$' + widget.selectItem.marketCap.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    )),
                          ],
                        ),
                        Column(
                          children: [
                            Text('24H VOLUEM',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                            SizedBox(
                              height: myHeight * 0.01,
                            ),
                            Text(
                              '\$' + widget.selectItem.high24H.toString(),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('RANK',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                            SizedBox(
                              height: myHeight * 0.01,
                            ),
                            Text(
                              '#' + widget.selectItem.marketCapRank.toString(),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.015,
                  ),
                  Container(
                    height: myHeight * 0.4,
                    width: myWidth,
                    // color: Colors.amber,
                    child: isRefresh == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffF004BFE),
                            ),
                          )
                        : itemChart == null
                            ? Padding(
                                padding: EdgeInsets.all(myHeight * 0.06),
                                child: Center(
                                  child: Text(
                                    'Attention this Api is free, so you cannot send multiple requests per second, please wait and try again later.',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                            : SfCartesianChart(
                                trackballBehavior: trackballBehavior,
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  zoomMode: ZoomMode.x,
                                ),
                                series: <LineSeries>[
                                  LineSeries<ChartModel, int>(
                                    dataSource: itemChart!,
                                    xValueMapper: (ChartModel sales, _) =>
                                        sales.time,
                                    yValueMapper: (ChartModel sales, _) => sales
                                        .close, // You can choose any other property like high, low, open, etc. based on your requirement.

                                    sortFieldValueMapper:
                                        (ChartModel sales, _) => sales.time,
                                    pointColorMapper: (ChartModel sales, _) =>
                                        color,

                                    animationDuration: 55,
                                  ),
                                  LineSeries<ChartModel, int>(
                                    dataSource: itemChart!,
                                    xValueMapper: (ChartModel sales, _) =>
                                        sales.time,
                                    yValueMapper: (ChartModel sales, _) => sales
                                        .close, // You can choose any other property like high, low, open, etc. based on your requirement.

                                    sortFieldValueMapper:
                                        (ChartModel sales, _) => sales.time,
                                    pointColorMapper: (ChartModel sales, _) =>
                                        Colors.red,

                                    animationDuration: 55,
                                  ),
                                  LineSeries<ChartModel, int>(
                                    dataSource: itemChart!,
                                    xValueMapper: (ChartModel sales, _) =>
                                        sales.time,
                                    yValueMapper: (ChartModel sales, _) => sales
                                        .close, // You can choose any other property like high, low, open, etc. based on your requirement.

                                    sortFieldValueMapper:
                                        (ChartModel sales, _) => sales.time,
                                    pointColorMapper: (ChartModel sales, _) =>
                                        Colors.green,

                                    animationDuration: 55,
                                  )
                                ],
                              ),
                  ),
                  SizedBox(
                    height: myHeight * 0.01,
                  ),
                  Center(
                    child: Container(
                      height: myHeight * 0.04,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: text.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: myWidth * 0.02),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  textBool = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                  textBool[index] = true;
                                });
                                setDays(text[index]);
                                getChart();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: myWidth * 0.03,
                                    vertical: myHeight * 0.005),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: textBool[index] == true
                                      ? Color(0xffF004BFE).withOpacity(0.3)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  text[index],
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Market capitalization',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                            SizedBox(
                              width: myWidth * 0.01,
                            ),
                            Icon(
                              Icons.help_outline_rounded,
                              size: 18,
                            ),
                            SizedBox(
                              width: myWidth * 0.08,
                            ),
                            Text('\$' + widget.selectItem.marketCap.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    )),
                          ],
                        ),
                        Row(
                          children: [
                            Text('24-hour trading volume',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                            SizedBox(
                              width: myWidth * 0.01,
                            ),
                            Icon(
                              Icons.help_outline_rounded,
                              size: 18,
                            ),
                            SizedBox(
                              width: myWidth * 0.04,
                            ),
                            Text(
                                '\$' + widget.selectItem.totalVolume.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    )),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Completely watered down review',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                            SizedBox(
                              width: myWidth * 0.01,
                            ),
                            Icon(
                              Icons.help_outline_rounded,
                              size: 18,
                            ),
                            SizedBox(
                              width: myWidth * 0.02,
                            ),
                            Text(
                                '\$' +
                                    widget.selectItem.currentPrice.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    )),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Number in circulation',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                            SizedBox(
                              width: myWidth * 0.01,
                            ),
                            Icon(
                              Icons.help_outline_rounded,
                              size: 18,
                            ),
                            SizedBox(
                              width: myWidth * 0.1,
                            ),
                            Text(
                                '\$' +
                                    widget.selectItem.circulatingSupply
                                        .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    )),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Entire offer',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                            SizedBox(
                              width: myWidth * 0.01,
                            ),
                            Icon(
                              Icons.help_outline_rounded,
                              size: 18,
                            ),
                            SizedBox(
                              width: myWidth * 0.3,
                            ),
                            Text(widget.selectItem.totalSupply.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    )),
                          ],
                        ),
                        Row(
                          //
                          children: [
                            Text('Maximum stock',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                            SizedBox(
                              width: myWidth * 0.01,
                            ),
                            Icon(
                              Icons.help_outline_rounded,
                              size: 18,
                            ),
                            SizedBox(
                              width: myWidth * 0.2,
                            ),
                            Text(widget.selectItem.maxSupply.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    ));
  }

  List<String> text = ['D', 'W', 'M', '3M', '6H', 'Y'];
  List<bool> textBool = [false, false, true, false, false, false];

  int days = 30;

  setDays(String txt) {
    if (txt == 'D') {
      setState(() {
        days = 1;
      });
    } else if (txt == 'W') {
      setState(() {
        days = 7;
      });
    } else if (txt == 'M') {
      setState(() {
        days = 30;
      });
    } else if (txt == '3M') {
      setState(() {
        days = 90;
      });
    } else if (txt == '6M') {
      setState(() {
        days = 180;
      });
    } else if (txt == 'Y') {
      setState(() {
        days = 365;
      });
    }
  }

  List<ChartModel>? itemChart;

  bool isRefresh = true;

  Future<void> getChart() async {
    String url = 'https://api.coingecko.com/api/v3/coins/' +
        widget.selectItem.id +
        '/ohlc?vs_currency=usd&days=' +
        days.toString();

    setState(() {
      isRefresh = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isRefresh = false;
    });
    if (response.statusCode == 200) {
      Iterable x = json.decode(response.body);
      List<ChartModel> modelList =
          x.map((e) => ChartModel.fromJson(e)).toList();
      setState(() {
        itemChart = modelList;
      });
    } else {
      print(response.statusCode);
    }
  }
}
