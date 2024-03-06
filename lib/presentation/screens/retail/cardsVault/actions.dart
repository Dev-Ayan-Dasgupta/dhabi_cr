import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/error.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({Key? key}) : super(key: key);

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> {
  bool isOnlinePayments = true;
  bool isPaymentAbroad = false;
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
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoCard(
              accountNumber: "",
              accountType: "",
              currency: "",
              balance: "",
              onTap: () {},
              name: "Multazam Siddiqui",
              iban: "AE12 3434 1313 1231 3535 34",
              bic: "DHILAEAD",
              flagImgUrl:
                  "https://static.vecteezy.com/system/resources/previews/004/712/234/non_2x/united-arab-emirates-square-national-flag-vector.jpg",
            ),
            const SizeBox(height: 20),
            Text(
              "Actions",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 15),
            Text(
              "Card",
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            ActionButton(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.errorSuccessScreen,
                  arguments: ErrorArgumentModel(
                    hasSecondaryButton: false,
                    iconPath: ImageConstants.checkCircleOutlined,
                    title: "Replacement Successful!",
                    message:
                        "Your card has been replaced with new virtual card",
                    buttonText: "Home",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    buttonTextSecondary: "",
                    onTapSecondary: () {},
                  ).toMap(),
                );
              },
              text: "Replace",
              isSelected: false,
              color: const Color(0XFFF8F8F8),
              fontColor: const Color(0XFF979797),
              boxShadow: const [],
            ),
            const SizeBox(height: 15),
            Text(
              "Payments",
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: const Color(0XFFF8F8F8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Online Payments",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0XFF979797),
                          fontSize: (16 / Dimensions.designWidth).w,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      BlocBuilder<ShowButtonBloc, ShowButtonState>(
                        builder: buildOnlinePaymentSwitch,
                      ),
                    ],
                  ),
                  const SizeBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payments abroad",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0XFF979797),
                          fontSize: (16 / Dimensions.designWidth).w,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      BlocBuilder<ShowButtonBloc, ShowButtonState>(
                        builder: buildAbroadPaymentSwitch,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnlinePaymentSwitch(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc onlinePaymentBloc = context.read<ShowButtonBloc>();
    return FlutterSwitch(
      width: (45 / Dimensions.designWidth).w,
      height: (25 / Dimensions.designWidth).w,
      activeColor: AppColors.green100,
      inactiveColor: const Color(0XFFD7D9D8),
      toggleSize: (15 / Dimensions.designWidth).w,
      value: isOnlinePayments,
      onToggle: (val) {
        isOnlinePayments = val;
        onlinePaymentBloc.add(ShowButtonEvent(show: isOnlinePayments));
      },
    );
  }

  Widget buildAbroadPaymentSwitch(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc paymentAbroadBloc = context.read<ShowButtonBloc>();
    return FlutterSwitch(
      width: (45 / Dimensions.designWidth).w,
      height: (25 / Dimensions.designWidth).w,
      activeColor: AppColors.green100,
      inactiveColor: const Color(0XFFD7D9D8),
      toggleSize: (15 / Dimensions.designWidth).w,
      value: isPaymentAbroad,
      onToggle: (val) {
        isPaymentAbroad = val;
        paymentAbroadBloc.add(ShowButtonEvent(show: isPaymentAbroad));
      },
    );
  }
}
