import 'dart:convert';

import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CustomDropdownCurrencies extends StatefulWidget {
  const CustomDropdownCurrencies({
    Key? key,
    required this.title,
    required this.items,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final List<DropDownCountriesModel> items;
  final Object? value;
  final Function(Object?) onChanged;

  @override
  State<CustomDropdownCurrencies> createState() =>
      _CustomDropdownCurrenciesState();
}

class _CustomDropdownCurrenciesState extends State<CustomDropdownCurrencies> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        // isExpanded: true,
        hint: SizedBox(
          width: 3.w,
          child: Row(
            children: [
              const SizeBox(width: 5),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyles.primary.copyWith(
                    color: const Color.fromRGBO(29, 29, 29, 0.5),
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
              ),
            ],
          ),
        ),
        items: widget.items
            .map(
              (item) => DropdownMenuItem<DropDownCountriesModel>(
                value: item,
                child: Row(
                  children: [
                    Text(
                      item.countrynameOrCode ?? "",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark80,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(width: 5),
                    CircleAvatar(
                      backgroundImage: MemoryImage(
                        base64Decode(item.countryFlagBase64 ?? ""),
                      ),
                      radius: (12.5 / Dimensions.designWidth).w,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        value: widget.value,
        onChanged: widget.onChanged,
        buttonStyleData: ButtonStyleData(
          height: (45 / Dimensions.designHeight).h,
          width: 15.w,
          padding: EdgeInsets.only(right: (0 / Dimensions.designWidth).w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular((10 / Dimensions.designWidth).w),
            ),
            boxShadow: const [],
            // border: Border.all(width: 1, color: const Color(0XFFEEEEEE)),
            color: Colors.white,
          ),
          elevation: 1,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          iconSize: (20 / Dimensions.designWidth).w,
          iconEnabledColor: Colors.transparent,
          iconDisabledColor: Colors.transparent,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: (200 / Dimensions.designHeight).h,
          width: 20.w,
          padding: null,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular((10 / Dimensions.designWidth).w),
            color: Colors.white,
          ),
          elevation: 8,
          offset: const Offset(0, -5),
          scrollbarTheme: ScrollbarThemeData(
            radius: Radius.circular((40 / Dimensions.designWidth).w),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: (40 / Dimensions.designWidth).w,
          padding: EdgeInsets.symmetric(
            horizontal: (14 / Dimensions.designWidth).w,
          ),
        ),
      ),
    );
  }
}
