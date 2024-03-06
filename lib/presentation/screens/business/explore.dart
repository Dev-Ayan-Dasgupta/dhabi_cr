import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BusinessExploreScreen extends StatefulWidget {
  const BusinessExploreScreen({Key? key}) : super(key: key);

  @override
  State<BusinessExploreScreen> createState() => _BusinessExploreScreenState();
}

class _BusinessExploreScreenState extends State<BusinessExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarMenu(),
        title: SvgPicture.asset(ImageConstants.appBarLogo),
        actions: [
          AppBarAction(
            notificationCount: notificationCount,
          )
        ],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            const SizeBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: (5 / Dimensions.designWidth).w),
              width: 100.w,
              height: (163 / Dimensions.designHeight).h,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.errorSuccessScreen,
                    arguments: ErrorArgumentModel(
                      hasSecondaryButton: false,
                      iconPath: ImageConstants.happy,
                      title: "You're all caught up",
                      message: labels[66]["labelText"],
                      buttonText: labels[347]["labelText"],
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      buttonTextSecondary: "",
                      onTapSecondary: () {},
                    ).toMap(),
                  );
                },
                child: Image.asset(
                  ImageConstants.banner2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 4,
            //     itemBuilder: (context, index) {
            //       // return Container(
            //       //   margin: EdgeInsets.symmetric(
            //       //       vertical: (5 / Dimensions.designWidth).w),
            //       //   width: 100.w,
            //       //   height: (131.47 / Dimensions.designWidth).w,
            //       //   child: Image.asset(
            //       //     ImageConstants.banner3,
            //       //     fit: BoxFit.fill,
            //       //   ),
            //       // );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
