import 'package:flutter/material.dart';
import 'package:maafos/Commons/TextStyles.dart';
import 'package:maafos/Screens/App/HomeInnerScreens/PopularInner.dart';

Widget popularCard({@required item, @required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PopularInner(
            categoryid: item.id,
          ),
        ),
      );
    },
    child: Column(
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Image.network(
              item.image.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            item.name,
            style: kText143,
          ),
        ),
      ],
    ),
  );
}
