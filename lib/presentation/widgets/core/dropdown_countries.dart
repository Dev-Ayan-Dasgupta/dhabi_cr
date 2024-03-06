// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/data/models/widgets/dropdown_countries.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class CustomDropdownCountries extends StatefulWidget {
  const CustomDropdownCountries({
    Key? key,
    required this.title,
    required this.items,
    this.value,
    required this.onChanged,
    this.height,
    this.maxHeight,
  }) : super(key: key);

  final String title;
  final List<DropDownCountriesModel> items;
  final Object? value;
  final Function(Object?) onChanged;
  final double? height;
  final double? maxHeight;

  @override
  State<CustomDropdownCountries> createState() =>
      _CustomDropdownCountriesState();
}

class _CustomDropdownCountriesState extends State<CustomDropdownCountries> {
  @override
  Widget build(BuildContext context) {
    log("Dropdown Countries called");
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
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
        items: widget.items
            .map(
              (item) => DropdownMenuItem<DropDownCountriesModel>(
                value: item,
                child: Row(
                  children: [
                    const SizeBox(width: 5),
                    CircleAvatar(
                      backgroundImage: MemoryImage(
                        base64Decode(item.countryFlagBase64 ?? ""),
                      ),
                      radius: (12.5 / Dimensions.designWidth).w,
                    ),
                    const SizeBox(width: 10),
                    Text(
                      item.countrynameOrCode ?? "",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark80,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        value: widget.value,
        onChanged: widget.onChanged,
        buttonStyleData: ButtonStyleData(
          height: ((widget.height ?? 55) / Dimensions.designHeight).h,
          width: 100.w,
          padding:
              EdgeInsets.symmetric(horizontal: (14 / Dimensions.designWidth).w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular((10 / Dimensions.designWidth).w),
            ),
            boxShadow: const [],
            border: Border.all(width: 1, color: const Color(0XFFEEEEEE)),
            color: Colors.white,
          ),
          elevation: 1,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          iconSize: (20 / Dimensions.designWidth).w,
          iconEnabledColor: const Color(0XFF1C1B1F),
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: ((widget.maxHeight ?? 300) / Dimensions.designHeight).h,
          width: 90.w,
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
