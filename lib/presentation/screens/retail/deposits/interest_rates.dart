import 'package:dialup_mobile_app/data/models/widgets/details_tile.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class InterestRatesScreen extends StatefulWidget {
  const InterestRatesScreen({Key? key}) : super(key: key);

  @override
  State<InterestRatesScreen> createState() => _InterestRatesScreenState();
}

class _InterestRatesScreenState extends State<InterestRatesScreen> {
  List<DetailsTileModel> rates = [];

  @override
  void initState() {
    super.initState();
    populateFdRates();
  }

  void populateFdRates() {
    rates.clear();
    for (var fdRate in fdRates) {
      rates.add(
          DetailsTileModel(key: fdRate["label"], value: "${fdRate["rate"]}%"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizeBox(height: 10),
            Text(
              "Interest Rates",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 30),
            Expanded(
              child: DetailsTile(
                length: rates.length,
                details: rates,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
