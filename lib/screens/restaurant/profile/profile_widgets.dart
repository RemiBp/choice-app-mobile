import 'dart:io';

import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:choice_app/l18n.dart';
import '../../../res/res.dart';

bottomSheet(BuildContext context,{

  File? imgFile,
}) {
  final provider = Provider.of<ProfileProvider>(context);
  return Container(
    height: getHeight() * .13,
    width: getWidth(),
    margin: EdgeInsets.symmetric(
      horizontal: getWidth() * .02,
      vertical: getHeight() * .02,
    ),
    child: Column(
      children: <Widget>[
        Text(
          al.chooseYourPhoto,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: getHeight() * .02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () {
               provider.getImage(isCamera: true);
              },
              label: Text(
                al.camera,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image_outlined),
              onPressed: () {
                provider.getImage(isCamera: false);
              },
              label: Text(
                al.gallery,
              ),
            ),
          ],
        )
      ],
    ),
  );
}