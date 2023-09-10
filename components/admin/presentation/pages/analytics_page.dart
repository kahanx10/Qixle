import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/components/admin/data/models/earnings_model.dart';
import 'package:amazon_clone/components/admin/data/services/admin_service.dart';
import 'package:amazon_clone/components/admin/presentation/widgets/earnings_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Earning>>(
        future: AdminService.getAnalytics(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            MessageService.showSnackBar(context,
                message: snapshot.error.toString());

            return const Center(
              child: Text('Error displaying analytics!'),
            );
          }

          if (snapshot.hasData) {
            var allEarnings = snapshot.data!;
            var totalEarnings = allEarnings.removeAt(0);

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Total Earnings: \$${totalEarnings.earning}'),
                  SizedBox(
                    height: 250,
                    child: EarningChart(earningsList: allEarnings),
                  ),
                ],
              ),
            );
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
