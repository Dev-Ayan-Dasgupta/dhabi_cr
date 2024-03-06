import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpSnippet extends StatelessWidget {
  const HelpSnippet({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        ImageConstants.help,
        width: (16.67 / Dimensions.designWidth).w,
        height: (16.67 / Dimensions.designWidth).w,
      ),
    );
  }
}
