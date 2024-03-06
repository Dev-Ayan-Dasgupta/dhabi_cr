import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarLeading(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(
              context,
              Routes.businessDashboard,
              arguments: RetailDashboardArgumentModel(
                imgUrl: "",
                name: "",
                isFirst: storageIsFirstLogin == true ? false : true,
              ).toMap(),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal:
                (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                    .w),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Thank you!\n\nTo proceed further, a link will be sent to your email.",
                      style: TextStyles.primary.copyWith(
                        color: const Color(0XFF414141),
                        fontSize: (20 / Dimensions.designWidth).w,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SolidButton(
                  onTap: () {},
                  text: labels[127]["labelText"],
                  color: AppColors.dark50,
                  fontColor: const Color(0xFF3B3B3B),
                ),
                const SizeBox(height: 32),
              ],
            )
          ],
        ),
      ),
    );
  }
}
