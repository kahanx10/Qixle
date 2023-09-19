// ignore_for_file: must_be_immutable

import 'package:amazon_clone/components/admin/data/models/earnings_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EarningChart extends StatelessWidget {
  final List<Earning> earningsList;
  var categoriesAvailable = <int, String>{};

  EarningChart({super.key, required this.earningsList});

  int maxEarnings = 0;

  @override
  Widget build(BuildContext context) {
    maxEarnings = earningsList
        .reduce((curr, next) => curr.earning > next.earning ? curr : next)
        .earning;

    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getTitles,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _generateBarGroups(),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < earningsList.length; i++) {
      categoriesAvailable[i] = earningsList[i].category;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              width: 25,
              borderRadius: BorderRadius.circular(4),
              toY: earningsList[i].earning.toDouble(),
              color: Colors.grey.shade800,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxEarnings.toDouble(),
                color: Colors.grey.shade300,
              ), // You can change the color if you want
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  Widget getTitles(double value, TitleMeta meta) {
    Widget text = Text(
      categoriesAvailable[value.toInt()]!,
      style: GoogleFonts.leagueSpartan(),
    );

    return text;
  }
}
