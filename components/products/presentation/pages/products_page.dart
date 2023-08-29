import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/presentation/widgets/my_app_bar.dart';
import 'package:amazon_clone/components/products/presentation/pages/add_product_page.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: const MyAppBar(
        title: Text('QIXA'),
        actions: [
          Text(
            'Admin',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
      body: const Center(
        child: Text('Products Page'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add A Product',
        onPressed: () {
          Navigator.of(context).pushNamed(AddProductPage.routeName);
        },
        backgroundColor: Constants.selectedColor,
        child: const Icon(
          Icons.add,
          color: Constants.backgroundColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
