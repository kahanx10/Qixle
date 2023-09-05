import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/cart/presentation/widgets/cart_product.dart';
import 'package:amazon_clone/components/home/presentation/pages/searched_products_page.dart';
import 'package:amazon_clone/components/home/presentation/widgets/address_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchedProductsPage.routeName,
      arguments: query,
    );
  }

  void navigateToAddress(int sum) {
    // Navigator.pushNamed(
    //   context,
    //   AddressScreen.routeName,
    //   arguments: sum.toString(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final user =
            (BlocProvider.of<UserBloc>(context).state as UserAuthenticatedState)
                .user;

        int sum = 0;

        user.cart
            .map((e) => sum += e['quantity'] * e['product']['price'] as int)
            .toList();

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: Constants.appBarGradient,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      margin: const EdgeInsets.only(left: 15),
                      child: Material(
                        borderRadius: BorderRadius.circular(7),
                        elevation: 1,
                        child: TextFormField(
                          onFieldSubmitted: navigateToSearchScreen,
                          decoration: InputDecoration(
                            prefixIcon: InkWell(
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 6,
                                ),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 23,
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 10),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black38,
                                width: 1,
                              ),
                            ),
                            hintText: 'Search Amazon.in',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 42,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Icon(Icons.mic, color: Colors.black, size: 25),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const AddressPanel(),
                // const CartSubtotal(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(
                    label: 'Proceed to Buy (${user.cart.length} items)',
                    onPressed: () => navigateToAddress(sum),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[600],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  color: Colors.black12.withOpacity(0.08),
                  height: 1,
                ),
                const SizedBox(height: 5),
                ListView.builder(
                  itemCount: user.cart.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (user.cart[index] == null) {
                      return null;
                    }

                    return CartProduct(
                      index: index,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
