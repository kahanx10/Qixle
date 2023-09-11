import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/home/logic/cubits/customer_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  _CategoryChipsState createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  String? _selectedChip;

  fetchCategorizedProducts(BuildContext context, String category) {
    final productsCubit = context.read<CustomerProductsCubit>();
    final authBloc = context.read<UserBloc>().state as UserAuthenticatedState;

    productsCubit.displayCategorizedProducts(
      category: category,
      token: authBloc.user.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    var categorySelected = context.read<CustomerProductsCubit>().state;

    if (categorySelected.runtimeType == ProductsFetched) {
      categorySelected as ProductsFetched;
      _selectedChip = categorySelected.products.first.category;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Flexible(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Categories',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 20,
                      color: Constants.selectedColor,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'See all',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14,
                      color: Colors.grey.shade300,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _buildCustomChip('Mobile'),
                  _buildCustomChip('Essentials'),
                  _buildCustomChip('Appliances'),
                  _buildCustomChip('Books'),
                  _buildCustomChip('Fashion'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomChip(String label) {
    bool isSelected = _selectedChip == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChip = label;
          fetchCategorizedProducts(context, label);
        });
      },
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20.0 : 12.0,
          vertical: 8,
        ),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.1,
                    ), // subtle shadow
                    blurRadius: 5, // soften the shadow
                    spreadRadius:
                        1, // extent of shadow, negative values can also be used
                    offset: const Offset(
                      -0.5,
                      0.5,
                    ), // Move to bottom-left by 4 units
                  ),
                ]
              : [],
          color:
              isSelected ? Constants.selectedColor : Constants.backgroundColor,
          border: Border.all(color: Constants.selectedColor, width: 2.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: GoogleFonts.leagueSpartan(
            fontSize: 14,
            color: isSelected
                ? Constants.backgroundColor
                : Constants.selectedColor,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}
