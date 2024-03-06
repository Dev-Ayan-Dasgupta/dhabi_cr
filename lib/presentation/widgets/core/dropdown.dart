import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    Key? key,
    required this.title,
    required this.items,
    this.value,
    required this.onChanged,
    this.leading,
  }) : super(key: key);

  final String title;
  final List<String> items;
  final Object? value;
  final Function(Object?) onChanged;
  final Widget? leading;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            widget.leading ?? const SizeBox(),
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
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    widget.leading ?? const SizeBox(),
                    Text(
                      item,
                      style: TextStyles.primary.copyWith(
                        color: const Color(0xFF292929),
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        value: widget.value,
        onChanged: widget.onChanged,
        buttonStyleData: ButtonStyleData(
          height: (50 / Dimensions.designHeight).h,
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
          maxHeight: (300 / Dimensions.designHeight).h,
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
          padding:
              EdgeInsets.symmetric(horizontal: (14 / Dimensions.designWidth).w),
        ),
      ),
    );
  }
}
