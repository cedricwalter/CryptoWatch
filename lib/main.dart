import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

void main() async {
  List prices = await getPrices();

  runApp(new MaterialApp(
    home: new Center(
      child: new TokenListWidget(prices),
    ),
  ));
}

Future<List> getPrices() async {
  String api = 'https://api.coinmarketcap.com/v1/ticker/?limit=40';
  http.Response response = await http.get(api);
  return json.decode(response.body);
}

class TokenListWidget extends StatelessWidget {
  final Random _random = new Random();
  final List<MaterialColor> _colors = [
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.yellow
  ];
  List _prices;

  TokenListWidget(this._prices);

  @override
  Widget build(BuildContext buildContext) {
    return new Scaffold(
      body: _buildBody(),
      backgroundColor: Colors.blue,
      floatingActionButton: new FloatingActionButton(onPressed: () async {
        // TODO implement refresh
      },
        child: new Icon(Icons.refresh), backgroundColor: Colors.lightBlue,
      ),
    );
  }

  Widget _buildBody() {
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 56.0, 8.0, 0.0),
      child: new Column(
        children: <Widget>[_getAppTitle(), _getListViewWidget()],
      ),
    );
  }

  Widget _getAppTitle() {
    return new Text(
      'CoinMarketCap Prices',
      style: new TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
    );
  }

  Widget _getListViewWidget() {
    return new Flexible(
        child: new ListView.builder(
            itemCount: _prices.length,
            itemBuilder: (context, index) {
              final Map price = _prices[index];
              final MaterialColor color = _colors[_random.nextInt(
                  _colors.length)];
              return _getListItemWidget(price, color);
            }),
    );
  }

  CircleAvatar _getLeadingWidget(String currencyName, MaterialColor color) {
    return new CircleAvatar(
      backgroundColor: color,
      child: new Text(currencyName[0],
      style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Text _getTitleWidget(String currencyName) {
    return new Text(
      currencyName,
      style: new TextStyle(fontWeight: FontWeight.bold),
    );
  }

  RichText _getSubtitleText(String priceUsd, String percentChange1h) {
    TextSpan priceTextWidget = new TextSpan(text: "\$$priceUsd\n", style: new TextStyle(color: Colors.black),);
    String percentChangeText = "1 hours: $percentChange1h%";
    TextSpan percentChangeWidget;
    Color itsColor;
    if (double.parse(percentChange1h) > 0) {
      itsColor = Colors.green;
    } else {
      itsColor = Colors.red;
    }
    percentChangeWidget = new TextSpan(text: percentChangeText, style: new TextStyle(color: itsColor),);


    return new RichText(text: new TextSpan(
      children: [
        priceTextWidget,
        percentChangeWidget
      ]
    ));
  }

  ListTile _getListTile(Map currency, MaterialColor color) {
    return new ListTile(
      leading: _getLeadingWidget(currency['name'], color),
      title: _getTitleWidget(currency['name']),
      subtitle: _getSubtitleText(currency['price_usd'], currency['percent_change_1h']),
      isThreeLine: true,
    );
  }

  Container _getListItemWidget(Map currency, MaterialColor color) {

    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: _getListTile(currency, color),
      ),
    );
  }








}