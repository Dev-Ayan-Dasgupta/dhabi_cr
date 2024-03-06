import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/tabs/tab.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ExploreDashboardScreen extends StatefulWidget {
  const ExploreDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ExploreDashboardScreen> createState() => _ExploreDashboardScreenState();
}

class _ExploreDashboardScreenState extends State<ExploreDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: promptUser,
          child: Padding(
            padding: EdgeInsets.all((20 / Dimensions.designWidth).w),
            child: SvgPicture.asset(ImageConstants.menu),
          ),
        ),
        title: InkWell(
          onTap: promptUser,
          child: SvgPicture.asset(ImageConstants.appBarLogo),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (20 / Dimensions.designWidth).w,
              vertical: (15 / Dimensions.designWidth).w,
            ),
            child: GradientButton(
              width: (90 / Dimensions.designWidth).w,
              height: (40 / Dimensions.designWidth).w,
              fontSize: (16 / Dimensions.designWidth).w,
              borderRadius: (5 / Dimensions.designWidth).w,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.referralCode,
                );
              },
              text: "Register",
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: tabController,
                indicatorColor: Colors.transparent,
                onTap: (index) {
                  setState(() {});
                },
                tabs: [
                  Tab(
                    child: CustomTab(
                      title: "Accounts",
                      isSelected: tabController.index == 0,
                    ),
                  ),
                  Tab(
                    child: CustomTab(
                        title: "Deposits",
                        isSelected: tabController.index == 1),
                  ),
                  Tab(
                    child: CustomTab(
                        title: "Explore", isSelected: tabController.index == 2),
                  ),
                ],
                isScrollable: true,
                labelColor: Colors.black,
                labelStyle: TextStyles.primaryMedium.copyWith(
                  color: const Color(0xFF000000),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
                tabAlignment: TabAlignment.start,
                dividerHeight: 0,
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: TextStyles.primaryMedium.copyWith(
                  color: const Color(0xFF000000),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              SizedBox(
                height: (480 / Dimensions.designHeight).h,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    // ! Accounts Tab
                    Column(
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: (145 / Dimensions.designWidth).w,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 2,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: (index == 0)
                                            ? (20 / Dimensions.designWidth).w
                                            : 0,
                                      ),
                                      child: AccountSummaryTile(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              Routes.exploreAccountDetails);
                                        },
                                        imgUrl: ImageConstants.usaFlag,
                                        accountType: index == 0
                                            ? labels[92]["labelText"]
                                            : labels[7]["labelText"],
                                        currency: "USD",
                                        amount: NumberFormat('#,000.00')
                                            .format(double.parse("10000.00")),
                                        subText: "",
                                        subImgUrl: "",
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: promptUser,
                          child: Column(
                            children: [
                              const SizeBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 47.w -
                                      ((3 - 1) *
                                          (6.5 / Dimensions.designWidth).w),
                                ),
                                child: SizedBox(
                                  width: 90.w,
                                  height: (9 / Dimensions.designWidth).w,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return ScrollIndicator(
                                        isCurrent: (index == 0),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizeBox(height: 20),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DashboardActivityTile(
                              iconPath: ImageConstants.arrowOutward,
                              activityText: "Send Money",
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.exploreSendMoney);
                              },
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: promptUser,
                          child: Column(
                            children: [
                              const SizeBox(height: 20),
                              SizedBox(
                                width: 100.w,
                                height: (109 / Dimensions.designHeight).h,
                                child: const DashboardBannerImage(
                                  imgUrl: ImageConstants.banner3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // ! Deposits Tab
                    Column(
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: (145 / Dimensions.designWidth).w,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: (index == 0)
                                            ? (20 / Dimensions.designWidth).w
                                            : 0,
                                      ),
                                      child: AccountSummaryTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.exploreCreateDeposit,
                                          );
                                        },
                                        imgUrl: ImageConstants.addAccount,
                                        accountType: "",
                                        currency: labels[103]["labelText"],
                                        amount: "",
                                        subText: "",
                                        subImgUrl: "",
                                        fontSize: 14,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizeBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DashboardActivityTile(
                              iconPath: ImageConstants.percent,
                              activityText: "Rates",
                              onTap: promptUser,
                            ),
                            const SizeBox(width: 25),
                            DashboardActivityTile(
                              iconPath: ImageConstants.add,
                              activityText: "Create Deposit",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.exploreCreateDeposit,
                                );
                              },
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: promptUser,
                          child: Column(
                            children: [
                              const SizeBox(height: 20),
                              SizedBox(
                                width: 100.w,
                                height: (109 / Dimensions.designHeight).h,
                                child: const DashboardBannerImage(
                                  imgUrl: ImageConstants.banner3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // ! Explore Tab
                    InkWell(
                      onTap: promptUser,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(ImageConstants.sentimentSatisfied),
                          const SizeBox(height: 16),
                          Text(
                            "You're all caught up",
                            style: TextStyles.primaryBold
                                .copyWith(color: AppColors.black),
                          ),
                          const SizeBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "Check back later for promotions and recommendations to keep your account up to date",
                              style: TextStyles.primaryMedium
                                  .copyWith(color: AppColors.dark80),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.33,
            minChildSize: 0.33,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return InkWell(
                onTap: promptUser,
                child: Stack(
                  children: [
                    Container(
                      height: 85.h,
                      width: 100.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: (10 / Dimensions.designWidth).w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular((20 / Dimensions.designWidth).w),
                        ),
                        boxShadow: [BoxShadows.primary],
                        color: Colors.white,
                      ),
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 51,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const SizeBox(height: 50);
                          }
                          return const SizeBox();
                        },
                      ),
                    ),
                    Positioned(
                      left: 44.w,
                      top: (10 / Dimensions.designWidth).w,
                      child: IgnorePointer(
                        child: Container(
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
                      ),
                    ),
                    Positioned(
                      left: (22 / Dimensions.designWidth).w,
                      top: (25 / Dimensions.designHeight).w,
                      child: IgnorePointer(
                        child: Text(
                          "Recent Transactions",
                          style: TextStyles.primary.copyWith(
                            color: const Color.fromRGBO(9, 9, 9, 0.4),
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: (125 / Dimensions.designWidth).w,
                      top: (100 / Dimensions.designHeight).h,
                      child: IgnorePointer(
                        child: Text(
                          "No Transactions",
                          style: TextStyles.primaryBold.copyWith(
                            color: AppColors.dark30,
                            fontSize: (24 / Dimensions.designWidth).w,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
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

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
