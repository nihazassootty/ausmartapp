import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maafos/Commons/ColorConstants.dart';
import 'package:maafos/Commons/TextStyles.dart';
import 'package:maafos/Commons/zerostate.dart';
import 'package:maafos/Components/CartBottomCard.dart';
import 'package:maafos/Components/GroceryCard.dart';
import 'package:maafos/Providers/GroceryProvider.dart';
import 'package:maafos/Shimmers/nearbydummy.dart';
import 'package:provider/provider.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPinkColor,
        title: Text(
          "Market",
          style: TextStyle(
            fontFamily: PrimaryFontName,
            fontSize: 20,
            color: kWhiteColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: cartBottomCard(),
      body: SingleChildScrollView(
        child: Consumer<GroceryProvider>(
          builder: (context, getstore, child) => getstore.loading
              ? nearrestaurantShimmer()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getstore.store.stores.length == 0
                        ? zerostate(
                            height: 300,
                            icon: 'assets/svg/noresta.svg',
                            head: 'Opps!',
                            sub: 'No Restaurants',
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: getstore.store.stores.length + 1,
                            itemBuilder: (context, int index) {
                              if (index == getstore.store.stores.length) {
                                return Offstage(
                                  offstage: getstore.isPagination,
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                              return groceryCard(
                                  item: getstore.store.stores[index],
                                  branch: getstore.store.branch.id,
                                  context: context);
                            },
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
