// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:maafos/Commons/AppConstants.dart';
// import 'package:maafos/Commons/ColorConstants.dart';
// import 'package:maafos/Commons/zerostate.dart';
// import 'package:maafos/Models/RestoProductModel.dart';
// import 'package:http/http.dart' as http;
// import 'package:maafos/Shimmers/appbardummy.dart';
// import 'package:maafos/Shimmers/nearbydummy.dart';

// class MenuModal extends StatefulWidget {
//   final id;
//   const MenuModal({Key key, @required this.id}) : super(key: key);

//   @override
//   _MenuModalState createState() => _MenuModalState();
// }

// class _MenuModalState extends State<MenuModal> {
//   bool loading = true;
//   RestoProductModel restaurant;
//   //* FETCH PRODUCTS AND CATEGORIES.
//   Future fetchProducts() async {
//     FlutterSecureStorage storage = FlutterSecureStorage();
//     final String token = await storage.read(key: "token");
//     try {
//       final Uri url = Uri.https(baseUrl, apiUrl + "/customer/rest-products/", {
//         "restId": widget.id,
//       });
//       final response = await http.get(url, headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       });
//       var res = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         setState(() {
//           restaurant = RestoProductModel.fromJson(res["data"]);
//           loading = false;
//         });
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   void initState() {
//     fetchProducts();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(right: 5),
//                       child: Icon(
//                         Icons.menu_book,
//                         size: 25,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       "View Menu",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w800,
//                         color: Colors.black54,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: const Icon(
//                     Icons.close,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Divider(
//               thickness: 1,
//             ),
//           ),
//           restaurant?.products?.length == 0
//               ? zerostate(
//                   height: 250,
//                   size: 80,
//                   icon: 'assets/svg/noproducts.svg',
//                   head: 'Ohh No!',
//                   sub: 'No Categories found!')
//               : restaurant?.products?.length != null
//                   ? ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: restaurant.products.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         var check = restaurant.products[index].category;
//                         return loading
//                             ? nearrestaurantShimmer()
//                             : Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 5),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // Navigator.pop(context);
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 right: 10),
//                                             child: ClipPath(
//                                               // clipper: TriangleClipper(),
//                                               // clipper: Clip.valu,
//                                               child: Container(
//                                                 height: 20,
//                                                 width: 30,
//                                                 color: kPinkColor,
//                                               ),
//                                             ),
//                                           ),
//                                           Text(
//                                             check.name,
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w400,
//                                               color: Colors.black,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 20),
//                                         child: Text(
//                                           restaurant
//                                               .products[index].products.length
//                                               .toString(),
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w700,
//                                             color: kPinkColor,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                       },
//                       // );
//                     )
//                   : appbarShimmer(),
//           SizedBox(
//             height: 50,
//           )
//         ],
//       ),
//     );
//   }
// }
