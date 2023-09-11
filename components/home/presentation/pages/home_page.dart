import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/cart/presentation/pages/cart_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/searched_products_page.dart';
import 'package:amazon_clone/components/home/presentation/widgets/category_chips.dart';
import 'package:amazon_clone/components/home/presentation/widgets/product_thumbnail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  static const String routeName = '/home_route';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Constants.backgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Discover',
            style: GoogleFonts.leagueSpartan(
              fontSize: 26,
              color: Constants.selectedColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 30.0,
              bottom: 5.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
              child: Stack(
                children: [
                  Container(
                    width: 35.0,
                    height: 35.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade100, width: 2),
                      borderRadius: BorderRadius.circular(100.0),
                      color: Constants.backgroundColor,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 18.0,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: BlocBuilder<UserBloc, UserState>(
                      buildWhen: (previous, current) {
                        return previous.runtimeType == UserAuthenticatedState;
                      },
                      builder: (context, state) {
                        var user = (BlocProvider.of<UserBloc>(context).state
                                as UserAuthenticatedState)
                            .user;

                        return user.cart.isNotEmpty
                            ? Badge(
                                backgroundColor: Constants.selectedColor,
                                label: Text(
                                  '${user.cart.length}',
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 10,
                                    color: Constants.backgroundColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : const SizedBox(
                                width: 0,
                                height: 0,
                              );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(6),
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: TextFormField(
                  controller: searchController,
                  onFieldSubmitted: (val) {
                    if (val.isNotEmpty) {
                      Navigator.of(context).pushNamed(
                        SearchedProductsPage.routeName,
                        arguments: val,
                      );
                    }
                  },
                  cursorColor: Constants.selectedColor,
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        if (searchController.text.isNotEmpty) {
                          Navigator.of(context).pushNamed(
                            SearchedProductsPage.routeName,
                            arguments: searchController.text,
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(
                          LineIcons.search,
                          color: Colors.black,
                          size: 23,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                    ),
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: GoogleFonts.leagueSpartan(
                      fontSize: 16,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            Stack(
              children: [
                Container(
                  height: 220,
                  constraints: const BoxConstraints(
                    // This ensures the height does not exceed 50 units.
                    minWidth:
                        0, // This means the width can be as small as possible.
                    maxWidth: double
                        .infinity, // This allows the width to expand as much as possible.
                  ),
                  margin: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.275), // subtle shadow
                        blurRadius: 15, // soften the shadow
                        spreadRadius:
                            1, // extent of shadow, negative values can also be used
                        offset: const Offset(
                          -3,
                          3,
                        ), // Move to bottom-left by 4 units
                      ),
                    ],
                    color: Constants.selectedColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        left: 20.0,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Clearance\nSales',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 30,
                              color: Constants.backgroundColor,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                          SizedBox(
                            width: 170,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Constants.selectedColor,
                                  backgroundColor: Constants.backgroundColor),
                              onPressed: () {},
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context)
                                      .style, // Default text style
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '% ',
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Up to 50%',
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -50), // Adjust the y value as needed
                  child: AbsorbPointer(
                    absorbing: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: CarouselSlider(
                        items: [
                          Transform.translate(
                            offset: const Offset(80, 10), //
                            child: Image.network(
                              'https://images.dailyobjects.com/marche/product-images/1101/dailyobjects-blue-hybrid-clear-case-cover-for-iphone-13-pro-max-images/DailyObjects-Blue-Hybrid-Clear-Case-Cover-for-iPhone-13-Pro-Max.png?tr=cm-pad_resize,v-2',
                              fit: BoxFit.cover,
                              height: 210,
                              width: 210,
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(60, -10), //
                            child: Image.network(
                              'https://www.freepnglogos.com/uploads/laptop-png/laptop-transparent-png-pictures-icons-and-png-40.png',
                              // fit: BoxFit.cover,
                              height: 250,
                              width: 250,
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(100, 65), //
                            child: Image.network(
                              'https://www.freepnglogos.com/uploads/women-bag-png/women-bag-women-shoulder-bags-png-transparent-images-27.png',
                              height: 180,
                              width: 180,
                            ),
                          ),
                          Transform.rotate(
                            angle: -45 * (math.pi / 180),
                            child: Transform.translate(
                              offset: const Offset(65, 15), //
                              child: Image.network(
                                'https://static.nike.com/a/images/t_default/e47bddea-7a42-4925-8f36-b4364b6fa12c/custom-nike-air-force-1-mid-by-you-shoes.png',
                                // fit: BoxFit.cover,
                                height: 265,
                                width: 265,
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(85, 50), //
                            child: Image.network(
                              'https://static.vecteezy.com/system/resources/previews/008/847/343/original/isolated-blue-front-sweater-free-png.png',
                              // fit: BoxFit.cover,
                              height: 350,
                              width: 350,
                            ),
                          ),
                        ],
                        options: CarouselOptions(
                          autoPlay: true,
                          autoPlayAnimationDuration: const Duration(seconds: 1),
                          height: 355,
                          viewportFraction: 1.0,
                          autoPlayCurve: Curves.elasticOut,
                        ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                    offset: const Offset(0, 295), child: const CategoryChips()),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 40.0,
              ),
              child: GridView.count(
                childAspectRatio: 3 / 4,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: const [
                  ProductThumbnail(
                    productName: 'AirPods',
                    productImage:
                        'https://www.pngmart.com/files/13/Apple-Airpods-PNG-Photos.png',
                    rating: 4.88,
                    price: 132.00,
                  ), //

                  ProductThumbnail(
                    productName: 'MacBook Air',
                    productImage:
                        'https://cdn.pixabay.com/photo/2020/06/26/12/21/macbook-pro-5342546_1280.png',
                    rating: 5.0,
                    price: 1100.0,
                  ), // here

                  ProductThumbnail(
                    productName: 'Comsetics Kit',
                    productImage:
                        'https://www.pngmart.com/files/17/Luxury-Cosmetics-PNG-Transparent-Image.png',
                    rating: 4.5,
                    price: 39,
                  ), //
                  ProductThumbnail(
                    productName: 'Bottle',
                    productImage:
                        'https://www.pngmart.com/files/1/Aluminium-Water-Bottle-PNG.png',
                    rating: 4.1,
                    price: 15,
                  ), //here
                ],
              ),
            ),
            // const DealOfTheDay(),
          ],
        ),
      ),
    );
  }
}
