import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/home/presentation/pages/searched_products_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

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
        backgroundColor: Constants.backgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(
            'Discover',
            style: GoogleFonts.leagueSpartan(
              fontSize: 30,
              color: Constants.selectedColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                      bottom: 10,
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
            const SizedBox(
              height: 10,
            ),
            // const AddressPanel(),
            // const RecommendedCategories(),
            // const SizedBox(height: 10),
            // CarouselImages(),
            Stack(
              children: [
                Container(
                  height: 240,
                  constraints: const BoxConstraints(
                    // This ensures the height does not exceed 50 units.
                    minWidth:
                        0, // This means the width can be as small as possible.
                    maxWidth: double
                        .infinity, // This allows the width to expand as much as possible.
                  ),
                  margin: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
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
                            'Clearance\nSale',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 30,
                              color: Constants.backgroundColor,
                              fontWeight: FontWeight.w500,
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
                Positioned(
                  bottom: -30,
                  right: -70,
                  child: Image.network(
                    'https://images.dailyobjects.com/marche/product-images/1101/dailyobjects-blue-hybrid-clear-case-cover-for-iphone-13-pro-max-images/DailyObjects-Blue-Hybrid-Clear-Case-Cover-for-iPhone-13-Pro-Max.png?tr=cm-pad_resize,v-2',
                    width: 350,
                    height: 350,
                  ),
                ),
              ],
            ),
            CarouselSlider(
              items: [
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3xKHxjX2DuksOHafIuXDnUycHmrw1HV1TOy6J5C-1cm-vRDm2g_U_Zri0JvMfB2MRchU&usqp=CAU',
                  width: 350,
                  height: 350,
                ),
              ],
              options: CarouselOptions(),
            )
            // const DealOfTheDay(),
          ],
        ),
      ),
    );
  }
}
