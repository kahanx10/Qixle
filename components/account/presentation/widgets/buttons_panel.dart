import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';

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
              Expanded(
                child: MyButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.backgroundColor,
                    foregroundColor: Constants.selectedColor,
                  ),
                  onPressed: () {},
                  text: 'Your Orders',
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: MyButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.backgroundColor,
                    foregroundColor: Constants.selectedColor,
                  ),
                  onPressed: () {},
                  text: 'Turn Seller',
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: MyButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.backgroundColor,
                    foregroundColor: Constants.selectedColor,
                  ),
                  onPressed: () {},
                  text: 'Wish List',
                ),
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
