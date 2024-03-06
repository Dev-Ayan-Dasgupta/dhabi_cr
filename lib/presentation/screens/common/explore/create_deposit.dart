import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ExploreCreateDepositScreen extends StatefulWidget {
  const ExploreCreateDepositScreen({super.key});

  @override
  State<ExploreCreateDepositScreen> createState() =>
      _ExploreCreateDepositScreenState();
}

class _ExploreCreateDepositScreenState
    extends State<ExploreCreateDepositScreen> {
  final TextEditingController _depositController =
      TextEditingController(text: "0.00");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          InkWell(
            onTap: promptUser,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (15 / Dimensions.designWidth).w,
                vertical: (15 / Dimensions.designWidth).w,
              ),
              child: SvgPicture.asset(ImageConstants.rates),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: InkWell(
          onTap: promptUser,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Deposits",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 10),
                    Text(
                      "Please fill out the following to create a deposit account.",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Choose the Account you wish to fund your Fixed Deposit",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.dark80,
                                    fontSize: (14 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const Asterisk(),
                              ],
                            ),
                            const SizeBox(height: 10),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: (context, state) {
                                return Flexible(
                                  child: SizedBox(
                                    height: (145 / Dimensions.designHeight).h,
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(
                                          top: (5 / Dimensions.designHeight).h,
                                          bottom:
                                              (12 / Dimensions.designHeight).h),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return AccountSummaryTile(
                                          isShowCheckMark: true,
                                          isSelected: index == 0 ? true : false,
                                          accountNumber: "081240924141",
                                          onTap: () {},
                                          imgUrl: ImageConstants.usaFlag,
                                          accountType: labels[7]["labelText"],
                                          currency: "USD",
                                          amount: "50,000.00",
                                          subText: "",
                                          subImgUrl: "",
                                          space: 21,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizeBox(height: 10),
                            BlocBuilder<SummaryTileBloc, SummaryTileState>(
                              builder: buildSummaryTile,
                            ),
                            const SizeBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(
                                  (10 / Dimensions.designWidth).w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                      (3 / Dimensions.designWidth).w),
                                ),
                                color: const Color(0xFFEEEEEE),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Amount Limit Criteria",
                                    style: TextStyles.primaryBold.copyWith(
                                      color: AppColors.primary,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizeBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Minimum amount required",
                                        style:
                                            TextStyles.primaryMedium.copyWith(
                                          color: AppColors.primary,
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                      Text(
                                        "USD ${NumberFormat('#,000.00').format(10000)}",
                                        style:
                                            TextStyles.primaryMedium.copyWith(
                                          color: AppColors.primary,
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizeBox(height: 7),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Maximum amount required",
                                        style:
                                            TextStyles.primaryMedium.copyWith(
                                          color: AppColors.primary,
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                      Text(
                                        "USD ${NumberFormat('#,000.00').format(100000)}",
                                        style:
                                            TextStyles.primaryMedium.copyWith(
                                          color: AppColors.primary,
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizeBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  "Deposit Amount (USD)",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.dark80,
                                    fontSize: (14 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const Asterisk(),
                              ],
                            ),
                            // const MandatoryFieldLabel(
                            //     labelText: "Deposit Amount (USD)"),
                            const SizeBox(height: 7),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: (context, state) {
                                return CustomTextField(
                                  borderColor: AppColors.dark30,
                                  controller: _depositController,
                                  keyboardType: TextInputType.number,
                                  hintText: "E.g., 20000",
                                  onChanged: (p0) {},
                                );
                              },
                            ),
                            const SizeBox(height: 5),

                            Row(
                              children: [
                                Text(
                                  labels[110]["labelText"],
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.dark80,
                                    fontSize: (14 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const Asterisk(),
                              ],
                            ),
                            // MandatoryFieldLabel(
                            //     labelText: labels[110]["labelText"]),
                            const SizeBox(height: 10),

                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: buildDepositColumn,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: buildSubmitButton,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDepositColumn(BuildContext context, ShowButtonState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizeBox(height: 10),
        Container(
          width: 100.w,
          padding: EdgeInsets.symmetric(
              horizontal: (15 / Dimensions.designWidth).w,
              vertical: (8 / Dimensions.designWidth).w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular((10 / Dimensions.designWidth).w)),
            color: AppColors.blackEE,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primaryDark,
                    size: (20 / Dimensions.designWidth).w,
                  ),
                  const SizeBox(width: 10),
                  Text(
                    labels[104]["labelText"],
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.primaryDark,
                      fontSize: (18 / Dimensions.designWidth).w,
                    ),
                  ),
                ],
              ),
              Text(
                "6.10%",
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: (18 / Dimensions.designWidth).w,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSummaryTile(BuildContext context, SummaryTileState state) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 47.w -
              (22 / Dimensions.designWidth).w -
              ((3 - 1) * (6.5 / Dimensions.designWidth).w)),
      child: SizedBox(
        width: 90.w,
        height: (9 / Dimensions.designWidth).w,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return ScrollIndicator(
              isCurrent: (index == 0),
            );
          },
        ),
      ),
    );
  }

  Widget buildErrorMessage(BuildContext context, ErrorMessageState state) {
    return const SizeBox();
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    return Column(
      children: [
        const SizeBox(height: 20),
        SolidButton(
          onTap: () {},
          text: labels[31]["labelText"],
        ),
        SizeBox(
          height: PaddingConstants.bottomPadding +
              MediaQuery.of(context).padding.bottom,
        ),
      ],
    );
  }

  void promptUser() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.checkCircleOutlined,
          title: "Done exploring?",
          message: "Register now and enjoy the world of digital banking!",
          auxWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                Routes.referralCode,
              );
            },
            text: "Register Now",
          ),
          actionWidget: SolidButton(
            fontColor: AppColors.primary,
            color: AppColors.primaryBright17,
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[166]["labelText"],
          ),
        );
      },
    );
  }
}
