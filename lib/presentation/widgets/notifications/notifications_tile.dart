// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class NotificationsTile extends StatelessWidget {
  const NotificationsTile({
    Key? key,
    required this.title,
    required this.message,
    required this.dateTime,
    required this.widget,
    required this.onPressed,
    required this.isActionable,
  }) : super(key: key);

  final String title;
  final String message;
  final String dateTime;
  final Widget widget;
  final void Function(BuildContext) onPressed;
  final bool isActionable;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          (Radius.circular((10 / Dimensions.designWidth).w)),
        ),
        color: Colors.white,
      ),
      child: Slidable(
        endActionPane: !isActionable
            ? ActionPane(
                extentRatio: 0.25,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: onPressed,
                    backgroundColor: AppColors.red100,
                    // foregroundColor: Colors.white,
                    icon: Icons.delete_forever_rounded,
                    label: "Delete",
                  ),
                ],
              )
            : null,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: (16 / Dimensions.designHeight).h,
            horizontal:
                (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              (Radius.circular((10 / Dimensions.designWidth).w)),
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
              ),
              const SizeBox(height: 7),
              Text(
                message,
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark50,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
                maxLines: 3,
              ),
              const SizeBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$dateTime GMT",
                    style: TextStyles.primaryMedium.copyWith(
                      color: const Color(0XFFA5ACB8),
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  widget,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
