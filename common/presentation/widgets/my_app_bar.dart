import 'package:amazon_clone/common/data/constant_data.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final double? elevation;
  // And any other properties we like.

  const MyAppBar({super.key, this.title, this.actions, this.elevation});

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
