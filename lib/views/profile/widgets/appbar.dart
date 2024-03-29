import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: const BackButton(
      color: AppColors.primaryColor,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
