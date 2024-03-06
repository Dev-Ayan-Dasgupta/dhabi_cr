import 'package:dialup_mobile_app/data/models/arguments/not_available.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class NotAvaiableScreen extends StatefulWidget {
  const NotAvaiableScreen({
    Key? key,
    required this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<NotAvaiableScreen> createState() => _NotAvaiableScreenState();
}

class _NotAvaiableScreenState extends State<NotAvaiableScreen> {
  late NotAvailableArgumentModel notAvailableArgumentModel;

  @override
  void initState() {
    super.initState();
    notAvailableArgumentModel =
        NotAvailableArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizeBox(height: 10),
                  Text(
                    messages[69]["messageText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 22),
                  RichText(
                    text: TextSpan(
                      text: "Thanks for your interest in joining Dhabi! ",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.grey40,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: notAvailableArgumentModel.country,
                          style: TextStyles.primaryBold.copyWith(
                            color: Colors.black,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' will soon be one of the many countries where Dhabi operates.',
                          style: TextStyles.primary.copyWith(
                            color: AppColors.grey40,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  GradientButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "Exit",
                  ),
                  const SizeBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
