import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:msf/components/category_card.dart';
import 'package:msf/components/my_text.dart';
import 'package:msf/constants.dart';
import 'package:msf/models/items.dart';
import 'package:msf/models/msf.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Msf> msf = [];
  bool loading = false;

  late BannerAd bannerAd;
  bool bannerAdLoaded = false;

  @override
  void initState() {
    super.initState();

    getCategories();
    createBannerAd();
  }

  @override
  void dispose() {
    super.dispose();

    bannerAd.dispose();
  }

  createBannerAd() {
    bannerAd = BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            bannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          bannerAd.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  getCategories() async {
    print("Loading data from github");

    setState(() {
      loading = true;
    });

    http.Response response = await http.get(
      Uri.parse(
        mainUrl + "msf.json",
      ),
    );

    Map data = json.decode(response.body);

    for (int i = 0; i < data["msf"].length; i++) {
      List items = data["msf"][i]["items"];

      Msf temp = Msf.fromJson(
        category: data["msf"][i]["category"],
        items: items
            .map(
              (e) => Items.fromJson(e),
            )
            .toList(),
      );
      msf.add(temp);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          "Movie Style Fonts",
          fontWeight: FontWeight.w700,
          fontSize: headingTextSize,
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(left: 16),
              child: ListView.builder(
                itemCount: msf.length,
                itemBuilder: (context, index) => CategoryCard(
                  category: msf[index].category,
                  items: msf[index].items,
                ),
              ),
            ),
      bottomNavigationBar: bannerAdLoaded
          ? Container(
              width: bannerAd.size.width.toDouble(),
              height: bannerAd.size.height.toDouble(),
              child: AdWidget(
                ad: bannerAd,
              ),
            )
          : null,
    );
  }
}
