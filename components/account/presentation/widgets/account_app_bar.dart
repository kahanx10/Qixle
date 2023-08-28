// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:amazon_clone/common/data/constant_data.dart';

class AccountAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final double? elevation;
  // And any other properties we like.

  const AccountAppBar({
    Key? key,
    this.title,
    this.actions,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
