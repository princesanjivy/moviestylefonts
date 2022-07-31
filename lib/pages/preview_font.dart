import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_cached_fonts/dynamic_cached_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:msf/components/my_spacer.dart';
import 'package:msf/components/my_text.dart';
import 'package:msf/constants.dart';
import 'package:msf/models/code.dart';
import 'package:msf/utils/save_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviewFont extends StatefulWidget {
  final String title, imageUrl, tag, code;
  final bool isLocked;

  PreviewFont({
    required this.title,
    required this.imageUrl,
    required this.tag,
    required this.code,
    required this.isLocked,
  });

  @override
  _PreviewFontState createState() => _PreviewFontState();
}

class _PreviewFontState extends State<PreviewFont> {
  GlobalKey _globalKey = GlobalKey();

  bool isTop = false;
  bool isLocked = false;
  bool isLoading = false;

  TextEditingController yourNameController = TextEditingController();

  Code? code;

  /// CODE
  /// ====
  /// align
  /// position
  /// size
  /// rotation
  /// color
  /// is3d
  /// isCaps

  late BannerAd bannerAd;
  bool bannerAdLoaded = false;

  late RewardedAd rewardedAd;
  bool rewardAdLoaded = false;

  @override
  void initState() {
    super.initState();

    getData();
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

  getData() async {
    setState(() {
      isLoading = true;
      isLocked = widget.isLocked;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getBool(widget.tag) ?? true) {
      DynamicCachedFonts dynamicCachedFont = DynamicCachedFonts(
        fontFamily: widget.title.toLowerCase() + "Font",
        url: mainUrl +
            "fonts/${widget.title.replaceAll(" ", "").toLowerCase()}font.ttf",
      );
      dynamicCachedFont.load();

      print("DOWNLOADING AND LOADED FONT");
    } else {
      DynamicCachedFonts.loadCachedFont(
        mainUrl +
            "fonts/${widget.title.replaceAll(" ", "").toLowerCase()}font.ttf",
        fontFamily: widget.title.toLowerCase() + "Font",
      );

      print("LOADED FONT");
    }

    code = Code.fromJson(widget.code.split(";"));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          // onPressed: () {
          //   FullScreenAd.object.createInterstitialAd();
          //   print(FullScreenAd.object.check());
          // },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        title: MyText(
          widget.title,
          fontWeight: FontWeight.w700,
          fontSize: headingTextSize,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              ),
            )
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: Stack(
                      alignment: code!.alignmentGeometry,
                      children: [
                        Hero(
                          tag: widget.tag,
                          child: AspectRatio(
                            aspectRatio: 0.70,
                            child: CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          top: code!.isTop ? code!.position : null,
                          bottom: !(code!.isTop) ? code!.position : null,
                          child: Text(
                            yourNameController.text == ""
                                ? code!.isCaps
                                    ? "YOUR NAME"
                                    : "your name"
                                : code!.isCaps
                                    ? yourNameController.text.toUpperCase()
                                    : yourNameController.text.toLowerCase(),
                            style: TextStyle(
                              fontFamily: widget.title.toLowerCase() + "Font",
                              fontSize: code!.fontSize,
                              color: code!.is3D ? code!.colors[0] : code!.color,
                              shadows: code!.is3D
                                  ? [
                                      Shadow(
                                        offset: Offset(3.5, 0),
                                        blurRadius: 0,
                                        color: code!.colors[1],
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalSpacer(8),
                MyText(
                  "1. Give your name in less than 10 characters for better result.",
                ),
                VerticalSpacer(2),
                MyText(
                  "2. Please don't use any special characters.",
                ),
                VerticalSpacer(2),
                MyText(
                  "3. Maximum only 15 characters.",
                ),
                VerticalSpacer(16),
                TextField(
                  controller: yourNameController,
                  maxLength: 15,
                  cursorColor: secondaryColor,
                  style: GoogleFonts.nunito(fontSize: bodyTextSize),
                  keyboardType: TextInputType.name,
                  // onSubmitted: (value) {
                  //   setState(() {});
                  // },
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: "Your Name",
                    labelStyle: GoogleFonts.nunito(
                      color: secondaryColor,
                    ),
                    hintText: "Enter your name here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: secondaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                VerticalSpacer(16),
                ElevatedButton(
                  onPressed: isLocked
                      ? () {
                          showDialog(
                            context: context,
                            builder: (ctx) => StatefulBuilder(
                                builder: (dialogContext, setState) {
                              RewardedAd.load(
                                adUnitId: rewardId,
                                request: AdRequest(),
                                rewardedAdLoadCallback: RewardedAdLoadCallback(
                                  onAdLoaded: (RewardedAd ad) {
                                    print('$ad loaded.');
                                    // Keep a reference to the ad so you can show it later.
                                    rewardedAd = ad;

                                    setState(() {
                                      rewardAdLoaded = true;
                                    });
                                  },
                                  onAdFailedToLoad: (LoadAdError error) {
                                    print('RewardedAd failed to load: $error');
                                  },
                                ),
                              );
                              return AlertDialog(
                                title: MyText(
                                  widget.title + " Font is Locked",
                                  fontWeight: FontWeight.w600,
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MyText("Watch an ad to unlock!"),
                                    VerticalSpacer(4),
                                    !rewardAdLoaded
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      secondaryColor),
                                            ),
                                          )
                                        : Container(),
                                    !rewardAdLoaded
                                        ? MyText("Loading ad...")
                                        : Container(),
                                    VerticalSpacer(8),
                                    ElevatedButton(
                                      onPressed: rewardAdLoaded
                                          ? () {
                                              rewardedAd.show(
                                                onUserEarnedReward:
                                                    (AdWithoutView ad,
                                                        RewardItem rewardItem) {
                                                  // Reward the user for watching an ad.
                                                  setState(() {
                                                    rewardAdLoaded = false;
                                                  });

                                                  Navigator.pop(dialogContext);

                                                  saveImage(
                                                    _globalKey,
                                                    yourNameController.text
                                                            .toLowerCase()
                                                            .trim() +
                                                        widget.title,
                                                    context,
                                                  );
                                                },
                                              );
                                            }
                                          : null,
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: MyText(
                                          "Watch Ad",
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        }
                      : () {
                          saveImage(
                            _globalKey,
                            yourNameController.text.toLowerCase().trim() +
                                widget.title,
                            context,
                          );
                        },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: MyText(
                      "Save Image",
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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
