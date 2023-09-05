import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/home/presentation/pages/categorized_products_page.dart';

import 'package:flutter/material.dart';

class RecommendedCategories extends StatelessWidget {
  const RecommendedCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        itemCount: Constants.categories.length,
        scrollDirection: Axis.horizontal,
        itemExtent: 85,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                CategorizedProductsPage.routeName,
                arguments: Constants.categories[index]['title'],
              );
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      Constants.categories[index]['image']!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                Text(
                  Constants.categories[index]['title']!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
