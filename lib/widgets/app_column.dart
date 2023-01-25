import 'dart:math';

import 'package:bitirme_projesi/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/dimensions.dart';
import 'icon_and_text_widgets.dart';

class AppColumn extends StatelessWidget {
  String text;


  AppColumn({required this.text});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${text}",style: TextStyle(fontSize: 20,fontFamily: "Varela",fontWeight: FontWeight.bold),),
        SizedBox(height: Dimensions.height10,),
        Row(
          children: [
            Wrap(
                children: List.generate(5, (index) => Icon(Icons.star,color: Colors.yellow.shade800,size: 15,))
            ),
            SizedBox(width: 10,),
            SmallText(text: "5"),
            SmallText(text: "(+200)",color: Colors.grey,),
            SizedBox(width: 10,),


          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconAndTextWidget(icon: Icons.circle_sharp, text: "Stok Var",iconColor: Colors.greenAccent),
            IconAndTextWidget(icon: Icons.shopping_bag, text: "Min ₺60.00",iconColor: Colors.red),
            IconAndTextWidget(icon: Icons.access_time_rounded, text: "25-45 dk",iconColor: Colors.deepOrange),


          ],
        )
      ],
    );
  }
}
