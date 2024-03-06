import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarAction extends StatelessWidget {
  const AppBarAction({
    Key? key,
    required this.notificationCount,
  }) : super(key: key);

  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.notifications);
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SvgPicture.asset(
              ImageConstants.notifications,
              width: (22 / Dimensions.designWidth).w,
              height: (27.5 / Dimensions.designWidth).w,
            ),
            notificationCount > 0
                ? Positioned(
                    right: 0,
                    child: Container(
                      width: (15 / Dimensions.designWidth).w,
                      height: (15 / Dimensions.designWidth).w,
                      decoration: const BoxDecoration(
                        color: AppColors.red100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "$notificationCount",
                          style: TextStyles.primary.copyWith(
                            color: Colors.white,
                            fontSize: (10 / Dimensions.designWidth).w,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizeBox(),
          ],
        ),
      ),
    );
  }
}
