import 'dart:developer';
import 'dart:io';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarLeading extends StatelessWidget {
  const AppBarLeading({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            bool canPop = Navigator.canPop(context);
            log("canPop -> $canPop");
            if (canPop) {
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    svgAssetPath: ImageConstants.warning,
                    title: "Exit App?",
                    message: "Do you really want to close the app?",
                    auxWidget: SolidButton(
                      color: AppColors.primaryBright17,
                      fontColor: AppColors.primary,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: "No",
                    ),
                    actionWidget: GradientButton(
                      onTap: () {
                        if (Platform.isAndroid) {
                          Navigator.pop(context);
                          SystemNavigator.pop();
                        } else {
                          Navigator.pop(context);
                          exit(0);
                        }
                      },
                      text: "Yes",
                    ),
                  );
                },
              );
            }
          },
      child: Container(
        width: (30 / Dimensions.designWidth).w,
        height: (30 / Dimensions.designWidth).w,
        padding: EdgeInsets.all((20 / Dimensions.designWidth).w),
        child: SvgPicture.asset(
          ImageConstants.arrowBack,
        ),
      ),
    );
  }
}

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (15 / Dimensions.designWidth).w,
      ),
      child: SvgPicture.asset(
        ImageConstants.menu,
      ),
    );
  }
}
