import 'package:dialup_mobile_app/bloc/showButton/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExploreSendMoneyScreen extends StatefulWidget {
  const ExploreSendMoneyScreen({super.key});

  @override
  State<ExploreSendMoneyScreen> createState() => _ExploreSendMoneyScreenState();
}

class _ExploreSendMoneyScreenState extends State<ExploreSendMoneyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: InkWell(
        onTap: promptUser,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (PaddingConstants.horizontalPadding /
                        Dimensions.designWidth)
                    .w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labels[9]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    "Please select an option to transfer funds",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  IgnorePointer(
                    child: TopicTile(
                      onTap: () {},
                      iconPath: ImageConstants.moveDown,
                      text: labels[149]["labelText"],
                    ),
                  ),
                  const SizeBox(height: 10),
                  IgnorePointer(
                    child: TopicTile(
                      onTap: () {},
                      iconPath: ImageConstants.accountBalance,
                      text: labels[150]["labelText"],
                    ),
                  ),
                  const SizeBox(height: 10),
                  IgnorePointer(
                    child: TopicTile(
                      onTap: () {},
                      iconPath: ImageConstants.public,
                      text: labels[152]["labelText"],
                    ),
                  ),
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.50,
              minChildSize: 0.50,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return ListView(
                  controller: scrollController,
                  children: [
                    Container(
                      height: 90.h,
                      width: 100.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: (PaddingConstants.horizontalPadding /
                                Dimensions.designWidth)
                            .w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0XFFEEEEEE)),
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular((20 / Dimensions.designWidth).w),
                          topRight:
                              Radius.circular((20 / Dimensions.designWidth).w),
                        ),
                        color: const Color(0xFFFFFFFF),
                      ),
                      child: Column(
                        children: [
                          const SizeBox(height: 15),
                          // ! Clip widget for drag
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: (10 / Dimensions.designWidth).w,
                            ),
                            height: (7 / Dimensions.designWidth).w,
                            width: (50 / Dimensions.designWidth).w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    (10 / Dimensions.designWidth).w),
                              ),
                              color: const Color(0xFFD9D9D9),
                            ),
                          ),
                          const SizeBox(height: 15),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              return Ternary(
                                condition: false,
                                truthy: Column(
                                  children: [
                                    const SizeBox(height: 120),
                                    SpinKitFadingCircle(
                                      color: AppColors.primary,
                                      size: (50 / Dimensions.designWidth).w,
                                    ),
                                  ],
                                ),
                                falsy: Ternary(
                                  condition: true,
                                  truthy: SizedBox(
                                    height: 85.h,
                                    child: Column(
                                      children: [
                                        // ! Recent Transactions
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              labels[10]["labelText"],
                                              style:
                                                  TextStyles.primary.copyWith(
                                                color: AppColors.dark50,
                                                fontSize: (16 /
                                                        Dimensions.designWidth)
                                                    .w,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizeBox(height: 15),
                                        // ! Sort filter bar
                                        Container(
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  (10 / Dimensions.designWidth)
                                                      .w),
                                            ),
                                            color: AppColors.primary10,
                                          ),
                                          padding: EdgeInsets.all(
                                            (10 / Dimensions.designWidth).w,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      ImageConstants.sort,
                                                      width: (10 /
                                                              Dimensions
                                                                  .designHeight)
                                                          .w,
                                                      height: (10 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                    ),
                                                    const SizeBox(width: 5),
                                                    Text(
                                                      "By Date",
                                                      style: TextStyles
                                                          .primaryMedium
                                                          .copyWith(
                                                        color:
                                                            AppColors.primary,
                                                        fontSize: (14 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizeBox(height: 15),
                                        // ! Transaction list
                                        Ternary(
                                          condition: false,
                                          truthy: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizeBox(height: 70),
                                              Text(
                                                "No transactions",
                                                style: TextStyles.primaryBold
                                                    .copyWith(
                                                  color: AppColors.dark30,
                                                  fontSize: (24 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                ),
                                              ),
                                            ],
                                          ),
                                          falsy: Expanded(
                                            child: ListView.builder(
                                              controller: scrollController,
                                              itemCount: 0,
                                              itemBuilder: (context, index) {
                                                return RecentTransferTile(
                                                  onTap: () {},
                                                  iconPath:
                                                      ImageConstants.moveDown,
                                                  name: "",
                                                  status: "",
                                                  amount: "0",
                                                  currency: "USD",
                                                  accountNumber: "",
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ! Sort filter UI
                                  falsy: SizedBox(
                                    height: 85.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Sort",
                                                    style: TextStyles
                                                        .primaryBold
                                                        .copyWith(
                                                            color: AppColors
                                                                .dark50,
                                                            fontSize: (20 /
                                                                    Dimensions
                                                                        .designWidth)
                                                                .w),
                                                  ),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyles
                                                          .primaryBold
                                                          .copyWith(
                                                              color: AppColors
                                                                  .primary,
                                                              fontSize: (16 /
                                                                      Dimensions
                                                                          .designWidth)
                                                                  .w),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizeBox(height: 20),
                                              Text(
                                                "Date",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                        color: AppColors.dark50,
                                                        fontSize: (16 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w),
                                              ),
                                              const SizeBox(height: 15),
                                              MultiSelectButton(
                                                isSelected: false,
                                                content: Text(
                                                  "Newest first",
                                                  style: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color:
                                                        AppColors.primaryDark,
                                                    fontSize: (18 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                                onTap: () {},
                                              ),
                                              const SizeBox(height: 10),
                                              MultiSelectButton(
                                                isSelected: true,
                                                content: Text(
                                                  "Oldest first",
                                                  style: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color:
                                                        AppColors.primaryDark,
                                                    fontSize: (18 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                                onTap: () {},
                                              ),
                                              const SizeBox(height: 20),
                                              Text(
                                                "Amount",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                        color: AppColors.dark50,
                                                        fontSize: (16 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w),
                                              ),
                                              const SizeBox(height: 15),
                                              MultiSelectButton(
                                                isSelected: true,
                                                content: Text(
                                                  "Highest amount first",
                                                  style: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color:
                                                        AppColors.primaryDark,
                                                    fontSize: (18 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                                onTap: () {},
                                              ),
                                              const SizeBox(height: 10),
                                              MultiSelectButton(
                                                isSelected: true,
                                                content: Text(
                                                  "Lowest amount first",
                                                  style: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color:
                                                        AppColors.primaryDark,
                                                    fontSize: (18 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                                onTap: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
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
