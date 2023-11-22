import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  final dynamic item;

  Item({
    required this.item,
  });

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: myWidth * 0.05,
        vertical: myHeight * 0.01,
      ),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: myHeight * 0.05,
                width: myWidth * 0.02,
                child: Image.network(widget.item.image),
              ),
            ),
            SizedBox(width: myWidth * 0.02),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.id,
                    style: TextStyle(
                        fontSize: myWidth * 0.04, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '0.4 ' + widget.item.symbol,
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
                  data: widget.item.sparklineIn7D.price,
                  lineWidth: 1.0,
                  lineColor: widget.item.marketCapChangePercentage24H >= 0
                      ? Colors.green
                      : Colors.red,
                  fillMode: FillMode.below,
                  fillGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.7],
                    colors: widget.item.marketCapChangePercentage24H >= 0
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
                    '\$ ' + widget.item.currentPrice.toString(),
                    style: TextStyle(
                        fontSize: myWidth * 0.04, fontWeight: FontWeight.bold),
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
                            : "\$" +
                                widget.item.priceChange24H.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: myWidth * 0.035,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: myWidth * 0.01),
                      Text(
                        widget.item.marketCapChangePercentage24H
                                .toStringAsFixed(2) +
                            '%',
                        style: TextStyle(
                          fontSize: myWidth * 0.035,
                          fontWeight: FontWeight.normal,
                          color: widget.item.marketCapChangePercentage24H >= 0
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
    );
  }
}
