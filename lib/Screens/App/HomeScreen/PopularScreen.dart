import 'package:flutter/material.dart';
import 'package:maafos/Commons/TextStyles.dart';
import 'package:maafos/Commons/zerostate.dart';
import 'package:maafos/Components/PopularCard.dart';
import 'package:maafos/Providers/PopularProvider.dart';
import 'package:maafos/Shimmers/categorydummy.dart';
import 'package:provider/provider.dart';

class PopularScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  text: "Popular",
                  style: TextHeadGrey,
                  children: <TextSpan>[
                    TextSpan(
                      text: "\tFoods",
                      style: TextHeadGrey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Consumer<PopularProvider>(
          builder: (context, data, child) => data.loading
              ? categoryShimmer()
              : data.category.count == 0
                  ? zerostate(
                      icon: 'assets/svg/norestaurant.svg',
                      head: 'Sorry!',
                      sub: 'No Restaurant is found')
                  : Container(
                      height: 220,
                      child: GridView.builder(
                        itemCount: data.category.count,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: popularCard(
                              item: data.category.data[index],
                              context: context,
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}
