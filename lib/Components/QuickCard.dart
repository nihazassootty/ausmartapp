import 'package:flutter/material.dart';
import 'package:maafos/Commons/TextStyles.dart';
import 'package:maafos/Models/StoreModel.dart';
import 'package:maafos/Screens/App/HomeInnerScreens/RestaurentDetails.dart';

Widget quickCard(
    {@required Quick item, @required branch, @required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurentDetail(item: item),
          ));
    },
    child: Stack(
      children: [
        Container(
          width: 160,
          height: 220,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Color(0x48EEEEEE), spreadRadius: 4, blurRadius: 20)
            ],
            image: DecorationImage(
              image: NetworkImage(item.storeBg.image),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: Text16white,
              ),
            ),
          ),
          // child: Image.network(
          //   item.storeBg.image,
          //   fit: BoxFit.cover,
          // ),
        ),
      ],
    ),
  );
}
