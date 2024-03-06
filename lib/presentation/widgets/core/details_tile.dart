// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class DetailsTile extends StatelessWidget {
  const DetailsTile({
    Key? key,
    required this.length,
    required this.details,
    this.coloredIndex,
    this.fontColor,
  }) : super(key: key);

  final int length;
  final List<DetailsTileModel> details;
  final int? coloredIndex;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: length,
            itemBuilder: (context, index) {
              return Container(
                width: 100.w,
                height: (40 / Dimensions.designHeight).h,
                padding: EdgeInsets.symmetric(
                  horizontal: (15 / Dimensions.designWidth).w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: (index == 0)
                        ? Radius.circular((10 / Dimensions.designWidth).w)
                        : const Radius.circular(0),
                    topRight: (index == 0)
                        ? Radius.circular((10 / Dimensions.designWidth).w)
                        : const Radius.circular(0),
                    bottomLeft: (index == length - 1)
                        ? Radius.circular((10 / Dimensions.designWidth).w)
                        : const Radius.circular(0),
                    bottomRight: (index == length - 1)
                        ? Radius.circular((10 / Dimensions.designWidth).w)
                        : const Radius.circular(0),
                  ),
                  color: (index % 2 == 0)
                      ? const Color(0xFFF7F7F7)
                      : const Color(0xFFEEEEEE),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      details[index].key,
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark80,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        details[index].value,
                        style: TextStyles.primary.copyWith(
                          color: (index == coloredIndex)
                              ? fontColor
                              : AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
