import 'package:amazon_clone/common/data/constant_data.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonsPanel extends StatelessWidget {
  const ButtonsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppButton(
                isExpanded: true,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstantData.backgroundColor,
                  foregroundColor: ConstantData.selectedColor,
                ),
                onPressed: () {},
                label: 'Your Orders',
              ),
              const SizedBox(
                width: 8,
              ),
              AppButton(
                isExpanded: true,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstantData.backgroundColor,
                  foregroundColor: ConstantData.selectedColor,
                ),
                onPressed: () {},
                label: 'Turn Seller',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppButton(
                isExpanded: true,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstantData.backgroundColor,
                  foregroundColor: ConstantData.selectedColor,
                ),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(SignOutUser());
                },
                label: 'Log Out',
              ),
              const SizedBox(
                width: 8,
              ),
              AppButton(
                isExpanded: true,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstantData.backgroundColor,
                  foregroundColor: ConstantData.selectedColor,
                ),
                onPressed: () {},
                label: 'Wish List',
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
