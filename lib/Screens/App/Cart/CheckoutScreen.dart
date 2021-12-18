import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maafos/Commons/AppConstants.dart';
import 'package:maafos/Commons/ColorConstants.dart';
import 'package:maafos/Commons/SnackBar.dart';
import 'package:maafos/Commons/TextStyles.dart';
import 'package:maafos/Components/CheckoutItem.dart';
import 'package:maafos/Providers/CartProvider.dart';
import 'package:maafos/Providers/GetDataProvider.dart';
import 'package:maafos/Screens/App/Cart/PaymentComplete.dart';
import 'package:maafos/Shimmers/nearbydummy.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CheckoutScreen extends StatefulWidget {
  double discountedTotal;
  var discount;
  var tip;

  CheckoutScreen({
    Key key,
    this.discountedTotal,
    this.discount,
    this.tip,
  }) : super(key: key);
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // ignore: unused_field
  String _value = "cash";
  bool loading = true;
  bool isServicable = true;
  int errorCode;
  dynamic charge = 0;

  void placeorder(itemtotal, totalpayable, deliverycharge, paymentType) async {
    var getcart = Provider.of<CartProvider>(context, listen: false);
    var getuser = Provider.of<GetDataProvider>(context, listen: false);
    Map<String, dynamic> data = {
      "vendor": getcart.store["storeId"],
      "vendorType": getcart.store["type"],
      "items": getcart.cart,
      "contactNumber": getuser.get.customer.user.username,
      "tip": widget.tip,
      "deliveryCharge": deliverycharge,
      "discount": widget.discount,
      "paymentType": paymentType,
      "address": getuser.address
    };

    FlutterSecureStorage storage = FlutterSecureStorage();
    final String token = await storage.read(key: "token");
    final Uri url = Uri.https(baseUrl, apiUrl + "/order");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(data),
    );

    var result = json.decode(response.body);

    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentComplete(
              orderData: result["data"]["orderId"],
              orderId: result["data"]["_id"],
            ),
          ),
          (route) => false);
      Provider.of<CartProvider>(context, listen: false).clearItem(context);
    } else {
      showSnackBar(
        duration: Duration(milliseconds: 100),
        context: context,
        message: "Order Cannot be placed,try again",
      );
    }
  }

  Future deliverycharge({latitude, longitude, restaurentid}) async {
    setState(() {
      loading = true;
    });
    FlutterSecureStorage storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");
    try {
      final Uri url = Uri.https(
        baseUrl,
        apiUrl + "/order/delivery/charge",
        {
          "vendor": restaurentid,
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
        },
      );

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      });

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          isServicable = true;
          charge = data["deliveryCharge"];
          loading = false;
        });
      }
      if (response.statusCode == 404) {
        setState(() {
          isServicable = false;
          charge = 0;
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  callBack() {
    final getmodel = Provider.of<GetDataProvider>(context, listen: false);
    final getcartmodel = Provider.of<CartProvider>(context, listen: false);
    deliverycharge(
        latitude: getmodel.latitude,
        longitude: getmodel.longitude,
        restaurentid: getcartmodel.store["storeId"]);
  }

  void initState() {
    super.initState();
    final getmodel = Provider.of<GetDataProvider>(context, listen: false);
    final getcartmodel = Provider.of<CartProvider>(context, listen: false);
    deliverycharge(
        latitude: getmodel.latitude,
        longitude: getmodel.longitude,
        restaurentid: getcartmodel.store["storeId"]);
  }

  TextEditingController _instructionController;
  // ignore: unused_field
  String _radioVal;
  @override
  Widget build(BuildContext context) {
    final getcartmodel = Provider.of<CartProvider>(context, listen: false);
    double itemtotal = getcartmodel.cart
        .map((item) => item["offerPrice"] != null ??
                item["offerPrice"] <= item["maafosPrice"]
            ? item["offerPrice"] * item["qty"]
            : item["maafosPrice"] * item["qty"])
        .fold(0, (prev, amount) => prev + amount);

    double totalpayable = widget.discountedTotal != null
        ? widget.tip != null
            ? double.parse(widget.tip) +
                widget.discountedTotal +
                charge.toDouble()
            : widget.discountedTotal + charge.toDouble()
        : widget.tip != null
            ? widget.tip == ''
                ? itemtotal + charge.toDouble()
                : double.parse(widget.tip) + itemtotal + charge.toDouble()
            : itemtotal + charge.toDouble();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: kWhiteColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: kBlackColor,
            ),
          ),
          title: Text(
            "Checkout",
            style: Text16black,
          )),
      body: Consumer<CartProvider>(
        builder: (context, data, child) => loading
            ? nearrestaurantShimmer()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.cart.length,
                      itemBuilder: (context, int index) {
                        return checkoutItemCard(
                          item: data.cart[index],
                          context: context,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.note,
                                    color: Colors.grey[700],
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  "Add a Note",
                                  style: Text18,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _instructionController,
                              minLines: 1,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText:
                                    'Feel free to mention any opinion or suggestion ',
                                hintStyle: kText10,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.note,
                                    color: Colors.grey[700],
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  "Bill Details",
                                  style: Text18,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Item Total",
                                  style: kNavBarTitle,
                                ),
                                Text(
                                  '₹ ' + itemtotal.toString(),
                                  style: kNavBarTitle,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery Charge",
                                  style: kNavBarTitle,
                                ),
                                Text(
                                  '₹${charge.toStringAsFixed(1)}\t',
                                  style: kNavBarTitle,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tip",
                                  style: kNavBarTitle,
                                ),
                                Text(
                                  widget.tip == null
                                      ? "Not Added"
                                      : widget.tip == ''
                                          ? "Not Added"
                                          : '₹ ' + widget.tip.toString(),
                                  style: kNavBarTitle,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Promo Code",
                                  style: kPink14,
                                ),
                                Text(
                                  widget.discountedTotal == null
                                      ? "Not Applied"
                                      : '₹ ' +
                                          widget.discount.toStringAsFixed(1),
                                  style: kPink14,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: kNavBarTitle,
                                ),
                                Text(
                                  '₹ ' + totalpayable.toString(),
                                  style: kNavBarTitle,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.payment,
                                    color: Colors.grey[700],
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  "Payment Mode",
                                  style: Text18,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 0.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Online Payment",
                                        style: kNavBarTitle,
                                      ),
                                      Radio(
                                        value: "online",
                                        groupValue: _value,
                                        activeColor: kPinkColor,
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
                                            _radioVal = '0';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Cash On Delivery",
                                        style: kNavBarTitle,
                                      ),
                                      Radio(
                                        value: "cash",
                                        groupValue: _value,
                                        activeColor: kPinkColor,
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
                                            _radioVal = '0';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, data, child) => data.cart.length == 0
            ? Container(
                height: 10,
              )
            : BottomAppBar(
                child: Container(
                  height: 120,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    "Delivery Address",
                                    style: kPink14,
                                  ),
                                ),
                                Icon(
                                  Icons.ac_unit,
                                  color: kPinkColor,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Consumer<GetDataProvider>(
                        builder: (context, details, child) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              details.fullAddress,
                              style: kNavBarTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Container(
                            // transform: Matrix4.translationValues(-15, 0, 0),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                placeorder(
                                  itemtotal,
                                  totalpayable,
                                  charge,
                                  _value,
                                );
                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => PaymentComplete(),
                                //     ),
                                //     (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: kPinkColor,
                              ),
                              child: Text(
                                "Place Order",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
