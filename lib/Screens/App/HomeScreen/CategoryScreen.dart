import 'package:flutter/material.dart';
import 'package:maafos/Commons/TextStyles.dart';
import 'package:maafos/Screens/App/HomeInnerScreens/MarketInner.dart';
import 'package:maafos/Screens/App/HomeInnerScreens/RestaurentInner.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RestaurentInner())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x48969696),
                          spreadRadius: 1,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/restaurent.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Center(
                                child: Text(
                                  "Restaurents",
                                  style: Text24white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/Rectangle1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MarketInner())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x48969696),
                            spreadRadius: 1,
                            blurRadius: 1)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/market.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Center(
                                child: Text(
                                  "Market",
                                  style: Text24white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/Rectangle1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
