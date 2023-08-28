import 'package:amazon_clone/common/data/constant_data.dart';
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
      backgroundColor: ConstantData.backgroundColor,
      appBar: const MyAppBar(
        title: Text('Qixle'),
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
        backgroundColor: ConstantData.selectedColor,
        child: const Icon(
          Icons.add,
          color: ConstantData.backgroundColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
