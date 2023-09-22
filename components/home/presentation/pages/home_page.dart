import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/cart/presentation/pages/cart_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/categorized_products_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/searched_products_page.dart';
import 'package:amazon_clone/components/home/presentation/widgets/category_chips.dart';
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

  void _showLogOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constants.selectedColor,
          title: Text(
            'Log Out',
            style: GoogleFonts.leagueSpartan(
              fontSize: 20,
              color: Constants.backgroundColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.025,
            ),
          ),
          content: Text(
            'Do you really want to go?',
            style: GoogleFonts.leagueSpartan(
              fontSize: 16,
              color: Constants.backgroundColor,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.025,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'No Stay',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14,
                      color: Constants.backgroundColor,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.025,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: Text(
                    'Yes, Bye',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.025,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    BlocProvider.of<UserBloc>(context).add(SignOutUser());
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          backgroundColor: Constants.backgroundColor,
          title: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'Discover',
              style: GoogleFonts.leagueSpartan(
                fontSize: 24,
                color: Constants.selectedColor,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.025,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 15.0,
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
                        border:
                            Border.all(color: Colors.grey.shade100, width: 2),
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
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 30.0,
                bottom: 5.0,
              ),
              child: GestureDetector(
                onTap: () {
                  _showLogOutDialog(context);
                },
                child: Stack(
                  children: [
                    Container(
                      width: 35.0,
                      height: 35.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade100, width: 2),
                        borderRadius: BorderRadius.circular(100.0),
                        color: Constants.backgroundColor,
                      ),
                      child: const Icon(
                        LineIcons.doorClosed,
                        size: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 2.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(top: 10, bottom: 20),
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(
                            LineIcons.search,
                            color: Constants.selectedColor,
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
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Transform.translate(
                    offset: const Offset(5, 5),
                    child: Container(
                      height: 200,
                      constraints: const BoxConstraints(
                        // This ensures the height does not exceed 50 units.
                        minWidth:
                            0, // This means the width can be as small as possible.
                        maxWidth: double
                            .infinity, // This allows the width to expand as much as possible.
                      ),
                      margin: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 2.0,
                          color: Constants.selectedColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    constraints: const BoxConstraints(
                      // This ensures the height does not exceed 50 units.
                      minWidth:
                          0, // This means the width can be as small as possible.
                      maxWidth: double
                          .infinity, // This allows the width to expand as much as possible.
                    ),
                    margin: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 2.0,
                        color: Constants.selectedColor,
                      ),
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
                                color: Colors.grey.shade300,
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                            ),
                            Stack(
                              children: [
                                Transform.translate(
                                    offset: const Offset(4, 4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      width: 170,
                                      height: 50,
                                    )),
                                SizedBox(
                                  width: 170,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor:
                                          Constants.backgroundColor,
                                      backgroundColor: Constants.selectedColor,
                                    ),
                                    onPressed: () {},
                                    child: RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize: 16,
                                          // fontWeight: FontWeight.w900,
                                          color: Constants.backgroundColor,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Up to 50 '.toUpperCase(),
                                            style: GoogleFonts.leagueSpartan(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.backgroundColor,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '% '.toUpperCase(),
                                            style: GoogleFonts.leagueSpartan(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset:
                        const Offset(0, -50), // Adjust the y value as needed
                    child: AbsorbPointer(
                      absorbing: true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: CarouselSlider(
                          items: [
                            Transform.translate(
                              offset: const Offset(100, 55), //
                              child: Image.asset(
                                'assets/images/purse.png',
                                height: 170,
                                width: 170,
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(70, -10),
                              child: Transform.rotate(
                                angle: -30 * (math.pi / 180),
                                child: Transform.flip(
                                  flipX: true,
                                  child: Image.asset(
                                    'assets/images/shoe-bg.png',
                                    fit: BoxFit.contain,
                                    height: 220,
                                    width: 220,
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(100, 50), //
                              child: Image.asset(
                                'assets/images/t-shirt.png',
                                fit: BoxFit.contain,
                                height: 170,
                                width: 170,
                              ),
                            ),
                            Transform.rotate(
                              angle: 20 * (math.pi / 180),
                              child: Transform.flip(
                                flipX: true,
                                child: Transform.translate(
                                  offset: const Offset(-90, 10), //
                                  child: Image.asset(
                                    'assets/images/umbrella.png',
                                    // fit: BoxFit.cover,
                                    height: 190,
                                    width: 190,
                                  ),
                                ),
                              ),
                            ),
                            Transform.flip(
                              flipX: true,
                              child: Transform.translate(
                                offset: const Offset(-90, 0), //
                                child: Image.asset(
                                  'assets/images/phone.png',
                                  // fit: BoxFit.cover,
                                  height: 240,
                                  width: 240,
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(80, 0), //
                              child: Image.asset(
                                'assets/images/laptop-3.png',
                                fit: BoxFit.contain,
                                height: 200,
                                width: 200,
                              ),
                            ),
                          ],
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayAnimationDuration:
                                const Duration(seconds: 1),
                            height: 355,
                            viewportFraction: 1.0,
                            autoPlayCurve: Curves.elasticOut,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, 270),
                    child: const CategoryChips(chipList: [
                      'Mobiles',
                      'Essentials',
                      'Appliances',
                      'Books',
                      'Fashion',
                    ]),
                  ),
                ],
              ),
              const CategorizedProducts(),
            ],
          ),
        ),
      ),
    );
  }
}
