import 'package:dialup_mobile_app/bloc/showButton/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExploreAccountDetailsScreen extends StatefulWidget {
  const ExploreAccountDetailsScreen({super.key});

  @override
  State<ExploreAccountDetailsScreen> createState() =>
      _ExploreAccountDetailsScreenState();
}

class _ExploreAccountDetailsScreenState
    extends State<ExploreAccountDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: promptUser,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (15 / Dimensions.designWidth).w,
                vertical: (15 / Dimensions.designWidth).w,
              ),
              child: SvgPicture.asset(ImageConstants.statement),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                      .w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account Details",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 20),
                InfoCard(
                  onTap: () {},
                  name: profileName ?? "",
                  iban: "XXXXXXXXXXXXXX",
                  bic: "XXXX",
                  flagImgUrl: "1234",
                  accountNumber: "XXXXXXXXXXXXXXXX",
                  accountType: "Current",
                  currency: "USD",
                  balance: "50,000.00",
                ),
                const SizeBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ternary(
                      condition: 1 == 2,
                      truthy: const SizeBox(),
                      falsy: DashboardActivityTile(
                        iconPath: ImageConstants.acUnit,
                        activityText: labels[70]["labelText"],
                        onTap: () {},
                      ),
                    ),
                    const SizeBox(width: 25),
                    DashboardActivityTile(
                      iconPath: ImageConstants.arrowOutward,
                      activityText: labels[9]["labelText"],
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.39,
            minChildSize: 0.39,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: [
                  // ! Outer Container
                  Container(
                    height: 90.h,
                    width: 100.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: (PaddingConstants.horizontalPadding /
                              Dimensions.designWidth)
                          .w,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: const Color(0XFFEEEEEE)),
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
                              Radius.circular((10 / Dimensions.designWidth).w),
                            ),
                            color: const Color(0xFFD9D9D9),
                          ),
                        ),
                        const SizeBox(height: 15),

                        BlocBuilder<ShowButtonBloc, ShowButtonState>(
                          builder: (context, state) {
                            return Ternary(
                              condition: true,
                              truthy: SizedBox(
                                height: 85.h,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          labels[10]["labelText"],
                                          style: TextStyles.primary.copyWith(
                                            color: AppColors.dark50,
                                            fontSize:
                                                (16 / Dimensions.designWidth).w,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                ImageConstants.download,
                                                width: (15 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                height: (15 /
                                                        Dimensions.designWidth)
                                                    .w,
                                              ),
                                              const SizeBox(width: 10),
                                              Text(
                                                labels[89]["labelText"],
                                                style:
                                                    TextStyles.primary.copyWith(
                                                  color: AppColors.dark50,
                                                  fontSize: (16 /
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
                                    const SizeBox(height: 15),
                                    Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              (10 / Dimensions.designWidth).w),
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
                                                  ImageConstants.filter,
                                                  width: (12 /
                                                          Dimensions
                                                              .designHeight)
                                                      .w,
                                                  height: (12 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                ),
                                                const SizeBox(width: 5),
                                                Text(
                                                  "All",
                                                  style: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color: AppColors.primary,
                                                    fontSize: (14 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizeBox(width: 10),
                                          Text(
                                            "|",
                                            style: TextStyles.primaryMedium
                                                .copyWith(
                                              color: AppColors.dark50,
                                              fontSize:
                                                  (16 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                          const SizeBox(width: 10),
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
                                                    color: AppColors.primary,
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
                                    Ternary(
                                      condition: 1 == 2,
                                      truthy: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizeBox(height: 70),
                                          Text(
                                            "No transactions",
                                            style:
                                                TextStyles.primaryBold.copyWith(
                                              color: AppColors.dark30,
                                              fontSize:
                                                  (24 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                        ],
                                      ),
                                      falsy: Expanded(
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            return DashboardTransactionListTile(
                                              onTap: () {},
                                              isCredit: true,
                                              title: "Inward Credit",
                                              name: "Alexander Doe",
                                              amount: 50.23,
                                              currency: "USD",
                                              date: "Tue, Apr 1 2022",
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              falsy: Ternary(
                                condition: true,
                                truthy: SizedBox(
                                  height:
                                      // _dsController.size,
                                      29.h,
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
                                                  "Filter",
                                                  style: TextStyles.primaryBold
                                                      .copyWith(
                                                          color:
                                                              AppColors.dark50,
                                                          fontSize: (20 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w),
                                                ),
                                              ],
                                            ),
                                            const SizeBox(height: 20),
                                            Text(
                                              "Transaction type",
                                              style: TextStyles.primaryMedium
                                                  .copyWith(
                                                      color: AppColors.dark50,
                                                      fontSize: (16 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w),
                                            ),
                                            const SizeBox(height: 15),
                                            Row(
                                              children: [
                                                SolidButton(
                                                  width: (118 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  color: Colors.white,
                                                  fontColor: AppColors.primary,
                                                  boxShadow: [
                                                    BoxShadows.primary
                                                  ],
                                                  borderColor:
                                                      const Color.fromRGBO(
                                                          0, 184, 148, 0.21),
                                                  onTap: () {},
                                                  text: "All",
                                                ),
                                                const SizeBox(width: 15),
                                                SolidButton(
                                                  width: (118 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  color: Colors.white,
                                                  fontColor: AppColors.primary,
                                                  boxShadow: [
                                                    BoxShadows.primary
                                                  ],
                                                  borderColor:
                                                      const Color.fromRGBO(
                                                          0, 184, 148, 0.21),
                                                  onTap: () {},
                                                  text: "Sent",
                                                ),
                                                const SizeBox(width: 15),
                                                SolidButton(
                                                  width: (118 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  color: Colors.white,
                                                  fontColor: AppColors.primary,
                                                  boxShadow: [
                                                    BoxShadows.primary
                                                  ],
                                                  borderColor:
                                                      const Color.fromRGBO(
                                                          0, 184, 148, 0.21),
                                                  onTap: () {},
                                                  text: "Received",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      GradientButton(
                                        onTap: () {},
                                        text: "Show 10 transactions",
                                      ),
                                    ],
                                  ),
                                ),
                                falsy: SizedBox(
                                  height:
                                      // _dsController.size,
                                      85.h,
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
                                                  style: TextStyles.primaryBold
                                                      .copyWith(
                                                          color:
                                                              AppColors.dark50,
                                                          fontSize: (20 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w),
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
                                              isSelected: true,
                                              content: Text(
                                                "Newest first",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                  color: AppColors.primaryDark,
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
                                              isSelected: false,
                                              content: Text(
                                                "Oldest first",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                  color: AppColors.primaryDark,
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
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                  color: AppColors.primaryDark,
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
                                              isSelected: false,
                                              content: Text(
                                                "Lowest amount first",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                  color: AppColors.primaryDark,
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
          SizedBox(
            height: 100.h,
            width: 100.w,
            child: InkWell(
              onTap: promptUser,
            ),
          )
        ],
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
