import 'package:flutter/material.dart';
import 'package:maafos/Commons/ColorConstants.dart';
import 'package:maafos/Commons/TextStyles.dart';
import 'package:maafos/Providers/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

Widget cartItemCard({item, context}) {
  final getmodel = Provider.of<CartProvider>(context, listen: false);
  final qty = getmodel.cart
      .firstWhere((element) => element["_id"] == item["_id"], orElse: () {
    return null;
  });
  addItemCart(val, qty) {
    Map item = {
      '_id': val["_id"],
      'name': val["name"],
      'maafosPrice': val["maafosPrice"],
      'packingCharge': val["packingCharge"],
      'price': val["price"],
      'offerPrice': val["offerPrice"],
      'qty': qty,
    };
    getmodel.addItem(item: item);
  }

  return Container(
    width: MediaQuery.of(context).size.width,
    color: kWhiteColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 190,
            child: Text(
              item["name"],
              style: kNavBarTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              Container(
                height: 30,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xFFFFFFFF),
                  border: Border.all(
                    color: kPinkColor,
                  ),
                ),
                child: SpinnerInput(
                  minValue: 0,
                  maxValue: 80,
                  step: 1,
                  plusButton: SpinnerButtonStyle(
                      elevation: 0,
                      color: Colors.transparent,
                      textColor: kBlackColor,
                      borderRadius: BorderRadius.circular(0)),
                  minusButton: SpinnerButtonStyle(
                      elevation: 0,
                      textColor: kBlackColor,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(0)),
                  middleNumberWidth: 25,
                  middleNumberStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: kBlackColor),
                  // spinnerValue: 10,
                  spinnerValue: qty == null ? 1 : qty["qty"].toDouble(),
                  onChange: (value) {
                    if (value == 0) {
                      getmodel.deleteItemCart(item);
                    } else {
                      addItemCart(item, value);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  item["offerPrice"] != null ??
                          item["offerPrice"] <= item["maafosPrice"]
                      ? '\u20B9' + (item["offerPrice"] * item["qty"]).toString()
                      : '\u20B9' +
                          (item["maafosPrice"] * item["qty"]).toString(),
                  style: kText143,
                ),
              ),
              IconButton(
                onPressed: () =>
                    Provider.of<CartProvider>(context, listen: false)
                        .deleteItemCart(item),
                iconSize: 10,
                icon: Icon(
                  Icons.delete_outline_outlined,
                  size: 18,
                  color: Colors.red[900],
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
