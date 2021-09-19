import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:msf/components/fullscreen_view.dart';
import 'package:msf/components/my_spacer.dart';
import 'package:msf/components/my_text.dart';
import 'package:msf/constants.dart';
import 'package:msf/helpers/navigation.dart';
import 'package:msf/helpers/show_interstitial_ad.dart';
import 'package:msf/models/items.dart';
import 'package:msf/pages/preview_font.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final List<Items> items;

  CategoryCard({
    required this.category,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigation.changeScreen(
                        context,
                        FullScreenView(
                          imageUrl:
                              mainUrl + "images/${category.toLowerCase()}.jpg",
                          tag: category.toLowerCase(),
                        ),
                      );
                    },
                    child: Hero(
                      tag: category.toLowerCase(),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: CachedNetworkImageProvider(
                          mainUrl + "images/${category.toLowerCase()}.jpg",
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                  HorizontalSpacer(8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        category,
                        fontWeight: FontWeight.w700,
                      ),
                      VerticalSpacer(2),
                      MyText(
                        "${items.length} movies",
                        fontSize: bodyTextSize - 2,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
              // IconButton(
              //   onPressed: () {
              //     // TODO
              //   },
              //   icon: Icon(
              //     Icons.arrow_forward_ios_rounded,
              //     color: secondaryColor,
              //   ),
              // ),
            ],
          ),
          VerticalSpacer(8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreviewFont(
                          title: items[index].movie,
                          code: items[index].code,
                          isLocked: items[index].isLocked,
                          tag: items[index].movie + category,
                          imageUrl: mainUrl +
                              "images/${items[index].movie.toString().toLowerCase().replaceAll(" ", "")}.jpg",
                        ),
                      ),
                    ).then((value) {
                      FullScreenAd.object.show();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 16,
                      right: index == items.length - 1 ? 16 : 0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Hero(
                        tag: items[index].movie + category,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CachedNetworkImage(
                              imageUrl: mainUrl +
                                  "images/${items[index].movie.toString().toLowerCase().replaceAll(" ", "")}.jpg",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            items[index].isNew
                                ? Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: MyText(
                                      "NEW",
                                      color: primaryColor,
                                      fontSize: 12,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
