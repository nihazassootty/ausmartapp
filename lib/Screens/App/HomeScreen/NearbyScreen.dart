import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maafos/Commons/TextStyles.dart';
import 'package:maafos/Commons/zerostate.dart';
import 'package:maafos/Components/NearbyCard.dart';
import 'package:maafos/Providers/StoreProvider.dart';
import 'package:maafos/Shimmers/nearbydummy.dart';
import 'package:provider/provider.dart';

class NearbyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoreProvider>(
      builder: (context, getstore, child) => getstore.loading
          ? nearrestaurantShimmer()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: "Near",
                      style: TextHeadGrey,
                      children: <TextSpan>[
                        TextSpan(
                          text: "\tme",
                          style: TextHeadGrey,
                        ),
                      ],
                    ),
                  ),
                ),
                getstore.store.restaurant.length == 0
                    ? zerostate(
                        height: 300,
                        icon: 'assets/svg/noresta.svg',
                        head: 'Opps!',
                        sub: 'No Restaurants',
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: getstore.store.restaurant.length + 1,
                        itemBuilder: (context, int index) {
                          if (index == getstore.store.restaurant.length) {
                            return Offstage(
                              offstage: getstore.isPagination,
                              child: CupertinoActivityIndicator(),
                            );
                          }
                          return nearbyCard(
                              item: getstore.store.restaurant[index],
                              branch: getstore.store.branch.id,
                              context: context);
                        },
                      ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SvgPicture.asset(
                    'assets/svg/logowhite.svg',
                    color: Colors.grey,
                    height: 35,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
    );
  }
}
