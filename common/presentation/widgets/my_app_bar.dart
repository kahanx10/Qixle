// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:amazon_clone/common/data/constant_data.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final double? elevation;
  final bool isTitleCentered;
  // And any other properties we like.

  const MyAppBar({
    Key? key,
    this.title,
    this.actions,
    this.elevation,
    this.isTitleCentered = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: isTitleCentered,
      title: title,
      actions: actions,
      elevation: elevation,
      // And any other properties we like.
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: ConstantData.appBarGradient,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
