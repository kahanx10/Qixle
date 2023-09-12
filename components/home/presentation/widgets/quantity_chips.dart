// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_clone/components/home/logic/cubits/quantity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:amazon_clone/common/data/constants.dart';

class QuantityChips extends StatefulWidget {
  final List<int> chipList;

  const QuantityChips({
    Key? key,
    required this.chipList,
  }) : super(key: key);

  @override
  _QuantityChipsState createState() => _QuantityChipsState();
}

class _QuantityChipsState extends State<QuantityChips> {
  int? _selectedChip;

  setQuantity(BuildContext context, int quantity) {
    context.read<QuantityCubit>().setQuantity(quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        widget.chipList.length,
        (index) => _buildCustomChip(widget.chipList[index]),
      ),
    );
  }

  Widget _buildCustomChip(int quantity) {
    bool isSelected = _selectedChip == quantity;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedChip == quantity) {
            _selectedChip = null;
            setQuantity(context, 0);
          } else {
            _selectedChip = quantity;
            setQuantity(context, quantity);
          }
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
          '$quantity pcs',
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
